extends TileMapLayer

# --- CONFIGURACIÓN DE PRUEBAS (DEBUG) ---
var MODO_PRUEBA: bool = false

@export_group("Configuración de Mapa")
@export var map_width: int = 80
@export var map_height: int = 40
@export var min_number_of_rooms: int = 10
@export var max_number_of_rooms: int = 15
@export var min_room_size: int = 5
@export var max_room_size: int = 15
@export var bigger_corridor: bool = false

@export_group("Entidades")
@export var item_scene: PackedScene 
@export var items_per_room: int = 2
@export var enemy_scene: PackedScene 
@export var enemy_2_scene: PackedScene 
@export var enemies_per_room: int = 1
@export var stairs_scene: PackedScene 
@export var treasure_scene: PackedScene 
@export var secret_treasure_scene: PackedScene 
@export_file("*.tscn") var next_level_scene: String

const SOURCE_ID: int = 0
const WALL_COORD := Vector2i(0, 0)
const FLOOR_COORD := Vector2i(0, 1)

var player_scene: PackedScene = preload("res://player.tscn")
var map_data: Array = []
var rooms: Array[Room] = []
var spawn_position: Vector2 
var player_instance: CharacterBody2D 

# --- CLASE ROOM ---
class Room:
	var x: int
	var y: int
	var w: int
	var h: int

	func random_pos_and_size(mw: int, mh: int, min_s: int, max_s: int) -> void:
		x = randi_range(1, mw - max_s - 2)
		y = randi_range(1, mh - max_s - 2)
		w = randi_range(min_s, max_s)
		h = randi_range(min_s, max_s)

	func mid() -> Vector2i:
		return Vector2i(x + w / 2, y + h / 2)

	func collides(check: Room) -> bool:
		var margin = 2
		return (x < check.x + check.w + margin and x + w + margin > check.x and
				y < check.y + check.h + margin and y + h + margin > check.y)

	func random_point_in_room() -> Vector2i:
		return Vector2i(randi_range(x + 1, x + w - 2), randi_range(y + 1, y + h - 2))

# --- FUNCIONES PRINCIPALES ---

func _ready() -> void:
	add_to_group("mapa")
	
	if get_tree().current_scene.name == "Nivel1":
		GlobalTimer.time_elapsed = 0.0
	GlobalTimer.is_active = true

	randomize()
	generate_dungeon_data()
	draw_map()
	
	spawn_player()
	spawn_items()
	spawn_enemies()
	spawn_stairs() 
	
	_limpiar_escaleras_fantasmas.call_deferred()
	
	await get_tree().process_frame
	
	var monedas_en_este_mapa = get_tree().get_nodes_in_group("items").size()
	if has_node("/root/GameEvents"):
		GameEvents.reset_counts(monedas_en_este_mapa)
		
		if MODO_PRUEBA and get_tree().current_scene.name == "Nivel3":
			GameEvents.total_treasures = 2
			print("[MODO PRUEBA] Simulado: Ya tienes 2 tesoros de los niveles anteriores.")
		
		if not GameEvents.treasure_collected.is_connected(_on_treasure_collected_check):
			GameEvents.treasure_collected.connect(_on_treasure_collected_check)
	
	if treasure_scene:
		_instanciar_tesoro(treasure_scene, false)

func _process(_delta: float) -> void:
	if not player_instance: return
	
	var p_cell = local_to_map(to_local(player_instance.global_position))
	var minimap = get_tree().get_first_node_in_group("minimap")
	
	if minimap:
		var cells_to_reveal: Array[Vector2i] = []
		var in_room = false
		for room in rooms:
			if p_cell.x >= room.x and p_cell.x < room.x + room.w and \
			   p_cell.y >= room.y and p_cell.y < room.y + room.h:
				for rx in range(room.x, room.x + room.w):
					for ry in range(room.y, room.y + room.h):
						cells_to_reveal.append(Vector2i(rx, ry))
				in_room = true
				break
		if not in_room:
			cells_to_reveal.append(p_cell)
			cells_to_reveal.append(p_cell + Vector2i.UP)
			cells_to_reveal.append(p_cell + Vector2i.DOWN)
			cells_to_reveal.append(p_cell + Vector2i.LEFT)
			cells_to_reveal.append(p_cell + Vector2i.RIGHT)
		minimap.reveal_cells(cells_to_reveal)

# --- LÓGICA DE SECRETOS Y EVENTOS ---

func _on_treasure_collected_check(_total_acumulado: int) -> void:
	if get_tree().current_scene.name == "Nivel3" and GameEvents.total_treasures == 3:
		if not get_parent().has_node("TESORO_SECRETO"):
			var escena = secret_treasure_scene if secret_treasure_scene else treasure_scene
			_instanciar_tesoro_secreto(escena)

func _instanciar_tesoro_secreto(escena: PackedScene) -> void:
	var t = escena.instantiate()
	t.name = "TESORO_SECRETO"
	
	# Le añadimos una variable al vuelo para decirle al cofre: "¡Tú eres el secreto!"
	if "es_tesoro_secreto" in t:
		t.es_tesoro_secreto = true
	
	get_parent().add_child.call_deferred(t)
	
	if rooms.size() > 1:
		var sala_random = rooms[randi_range(1, rooms.size() - 1)]
		t.global_position = map_to_local(sala_random.random_point_in_room())
		
		
		# Imprime el mensaje unificado que querías
		print("¡El tesoro ha aparecido en una sala aleatoria! ¡Ve a buscarlo!")

# --- ENTIDADES ---

func _instanciar_tesoro(escena: PackedScene, es_secreto: bool) -> void:
	var t = escena.instantiate()
	get_parent().add_child.call_deferred(t)
	if rooms.size() > 1:
		var sala_random = rooms[randi_range(1, rooms.size() - 1)]
		t.global_position = map_to_local(sala_random.random_point_in_room())
		

func spawn_stairs() -> void:
	if not stairs_scene or rooms.is_empty(): return
	var last_room = rooms.back() 
	var inst = stairs_scene.instantiate()
	inst.name = "ESCALERA_REAL" 
	get_parent().add_child.call_deferred(inst)
	inst.global_position = map_to_local(last_room.mid())
	if "next_scene_path" in inst:
		inst.next_scene_path = next_level_scene

func _limpiar_escaleras_fantasmas() -> void:
	for child in get_parent().get_children():
		if child is Area2D and "escalera" in child.name.to_lower():
			if child.name != "ESCALERA_REAL":
				child.free()

func spawn_player() -> void:
	if rooms.is_empty(): return
	player_instance = player_scene.instantiate()
	get_parent().add_child.call_deferred(player_instance)
	spawn_position = map_to_local(rooms[0].mid())
	player_instance.global_position = spawn_position

func spawn_items() -> void:
	if not item_scene: return
	for i in range(1, rooms.size()):
		for j in range(randi_range(1, items_per_room)):
			var inst = item_scene.instantiate()
			inst.add_to_group("items") 
			get_parent().add_child.call_deferred(inst)
			inst.global_position = map_to_local(rooms[i].random_point_in_room())

func spawn_enemies() -> void:
	if not enemy_scene: return
	for i in range(1, rooms.size()):
		for j in range(enemies_per_room):
			var inst = (enemy_2_scene.instantiate() if enemy_2_scene and randf() > 0.5 else enemy_scene.instantiate())
			inst.add_to_group("enemies")
			get_parent().add_child.call_deferred(inst)
			inst.global_position = map_to_local(rooms[i].random_point_in_room())

# --- GENERACIÓN TÉCNICA ---

func initialize_map_data() -> void:
	map_data.clear()
	map_data.resize(map_width)
	for i in range(map_width):
		map_data[i] = []; map_data[i].resize(map_height); map_data[i].fill(0)

func clear_data() -> void:
	initialize_map_data()
	rooms.clear()

func generate_dungeon_data() -> void:
	clear_data()
	var room_count = randi_range(min_number_of_rooms, max_number_of_rooms)
	for i in range(room_count):
		var new_room := Room.new()
		var attempts = 0
		while attempts < 100:
			new_room.random_pos_and_size(map_width, map_height, min_room_size, max_room_size)
			if not does_collide(new_room): break
			attempts += 1
		if attempts < 100:
			rooms.append(new_room)
			for tx in range(new_room.x, new_room.x + new_room.w):
				for ty in range(new_room.y, new_room.y + new_room.h):
					map_data[tx][ty] = 1
	create_corridors(); add_walls()

func does_collide(room: Room) -> bool:
	for existing in rooms:
		if room.collides(existing): return true
	return false

func create_corridors() -> void:
	for i in range(rooms.size() - 1): connect_points(rooms[i].mid(), rooms[i+1].mid())

func connect_points(p1: Vector2i, p2: Vector2i) -> void:
	var curr = p1
	while curr != p2:
		if randf() > 0.5:
			if curr.x != p2.x: curr.x += signi(p2.x - curr.x)
			else: curr.y += signi(p2.y - curr.y)
		else:
			if curr.y != p2.y: curr.y += signi(p2.y - curr.y)
			else: curr.x += signi(p2.x - curr.x)
		map_data[curr.x][curr.y] = 1
		if bigger_corridor:
			if curr.x + 1 < map_width: map_data[curr.x + 1][curr.y] = 1
			if curr.y + 1 < map_height: map_data[curr.x][curr.y + 1] = 1

func add_walls() -> void:
	for x in range(map_width):
		for y in range(map_height):
			if map_data[x][y] == 1:
				for cx in range(x - 1, x + 2):
					for cy in range(y - 1, y + 2):
						if cx >= 0 and cx < map_width and cy >= 0 and cy < map_height:
							if map_data[cx][cy] == 0: map_data[cx][cy] = 2

func draw_map() -> void:
	clear()
	for x in range(map_width):
		for y in range(map_height):
			if map_data[x][y] == 1: set_cell(Vector2i(x,y), SOURCE_ID, FLOOR_COORD)
			elif map_data[x][y] == 2: set_cell(Vector2i(x,y), SOURCE_ID, WALL_COORD)
