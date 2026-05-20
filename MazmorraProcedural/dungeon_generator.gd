extends TileMapLayer

@export var map_width: int = 80
@export var map_height: int = 40
@export var min_number_of_rooms: int = 10
@export var max_number_of_rooms: int = 15
@export var min_room_size: int = 5
@export var max_room_size: int = 15
@export var bigger_corridor: bool = false

const SOURCE_ID: int = 0
const WALL_COORD := Vector2i(0, 0)
const FLOOR_COORD := Vector2i(0, 1)

var player_scene: PackedScene = preload("res://player.tscn")

var map_data: Array = []
var rooms: Array[Room] = []

class Room:
	var x: int
	var y: int
	var w: int
	var h: int

	func random_pos_and_size(
		map_width: int, map_height: int,
		min_room_size: int, max_room_size: int
	) -> void:
		x = randi_range(1, map_width - max_room_size - 2)
		y = randi_range(1, map_height - max_room_size - 2)
		w = randi_range(min_room_size, max_room_size)
		h = randi_range(min_room_size, max_room_size)

	func mid() -> Vector2i:
		return Vector2i(x + w / 2, y + h / 2)

	func collides(check: Room) -> bool:
		var margin = 2
		return (
			x < check.x + check.w + margin and
			x + w + margin > check.x and
			y < check.y + check.h + margin and
			y + h + margin > check.y
		)

	func random_point_in_room() -> Vector2i:
		return Vector2i(
			randi_range(x, x + w - 1),
			randi_range(y, y + h - 1)
		)

	func _to_string() -> String:
		return "Room [x:%d, y:%d, w:%d, h:%d]" % [x, y, w, h]

func _ready() -> void:
	randomize()
	generate_dungeon_data()
	draw_map()
	spawn_player()

func initialize_map_data() -> void:
	map_data.clear()
	map_data.resize(map_width)
	for i in range(map_width):
		map_data[i] = []
		map_data[i].resize(map_height)
		map_data[i].fill(0)

func clear_data() -> void:
	initialize_map_data()
	rooms.clear()

func generate_dungeon_data() -> void:
	clear_data()
	var room_count: int = randi_range(
		min_number_of_rooms, max_number_of_rooms
	)

	for i in range(room_count):
		var new_room := Room.new()
		var attempts = 0
		var max_attempts = 100

		while attempts < max_attempts:
			new_room.random_pos_and_size(
				map_width, map_height,
				min_room_size, max_room_size
			)
			if not does_collide(new_room):
				break
			attempts += 1

		if attempts == max_attempts:
			print(
				"Warning: Could not place room %d after %d attempts." %
				[i, max_attempts]
			)
			continue

		rooms.append(new_room)
		for tile_x in range(new_room.x, new_room.x + new_room.w):
			for tile_y in range(new_room.y, new_room.y + new_room.h):
				if tile_x >= 0 and tile_x < map_width and \
				   tile_y >= 0 and tile_y < map_height:
					map_data[tile_x][tile_y] = 1

	create_corridors()
	add_walls()

func does_collide(room: Room) -> bool:
	for existing_room in rooms:
		if room.collides(existing_room):
			return true
	return false

func create_corridors() -> void:
	if rooms.size() < 2:
		return

	for i in range(rooms.size() - 1):
		var room_a = rooms[i]
		var room_b = rooms[i + 1]
		var point_a := room_a.random_point_in_room()
		var point_b := room_b.random_point_in_room()
		connect_points(point_a, point_b)

func connect_points(point_a: Vector2i, point_b: Vector2i) -> void:
	var current_pos := point_a

	while current_pos != point_b:
		if current_pos.x != point_b.x:
			var move_dir = signi(point_b.x - current_pos.x)
			current_pos.x += move_dir
		elif current_pos.y != point_b.y:
			var move_dir = signi(point_b.y - current_pos.y)
			current_pos.y += move_dir

		if current_pos.x >= 0 and current_pos.x < map_width and \
		   current_pos.y >= 0 and current_pos.y < map_height:
			map_data[current_pos.x][current_pos.y] = 1
			if bigger_corridor:
				if current_pos.x + 1 < map_width:
					map_data[current_pos.x + 1][current_pos.y] = 1
				if current_pos.y + 1 < map_height:
					map_data[current_pos.x][current_pos.y + 1] = 1
				if current_pos.x + 1 < map_width and \
				   current_pos.y + 1 < map_height:
					map_data[current_pos.x + 1][current_pos.y + 1] = 1

func add_walls() -> void:
	for x in range(map_width):
		for y in range(map_height):
			if map_data[x][y] == 1:
				for check_x in range(x - 1, x + 2):
					for check_y in range(y - 1, y + 2):
						if check_x == x and check_y == y:
							continue
						if check_x >= 0 and check_x < map_width and \
						   check_y >= 0 and check_y < map_height:
							if map_data[check_x][check_y] == 0:
								map_data[check_x][check_y] = 2

func draw_map() -> void:
	clear()
	for x in range(map_width):
		for y in range(map_height):
			var tile_type = map_data[x][y]
			var cell_coord = Vector2i(x, y)
			if tile_type == 1:
				set_cell(cell_coord, SOURCE_ID, FLOOR_COORD)
			elif tile_type == 2:
				set_cell(cell_coord, SOURCE_ID, WALL_COORD)

func get_start_position_world() -> Vector2:
	if rooms.is_empty():
		return map_to_local(Vector2i(map_width / 2, map_height / 2))

	var start_tile_coord: Vector2i = rooms[0].mid()
	var tile_size = tile_set.tile_size
	var world_pos = map_to_local(start_tile_coord) + tile_size / 2.0
	return world_pos

func spawn_player() -> void:
	if player_scene == null:
		print("Error: Player scene not set in Dungeon node inspector.")
		return
	if rooms.is_empty():
		print("Error: No rooms generated, cannot spawn player.")
		return

	var player_instance = player_scene.instantiate()
	var world_node = get_parent()
	if world_node:
		world_node.add_child.call_deferred(player_instance)
		player_instance.global_position = get_start_position_world()
		print("Player spawned at: ", player_instance.global_position)
	else:
		print("Error: Dungeon node must be a child of the World scene.")
