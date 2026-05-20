extends Node3D

@export var width: int = 15
@export var height: int = 15
@export var cell_size: float = 4.0
@export var wall_height: float = 3.0

var maze: Array = []
var player_spawn: Vector3 = Vector3.ZERO
var exit_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	randomize()
	generate_maze()
	generate_floor()
	place_player()
	place_exit()

func generate_maze() -> void:
	maze.clear()
	for y: int in range(height):
		maze.append([])
		for x: int in range(width):
			maze[y].append(true)

	var stack: Array[Vector2i] = []
	var pos: Vector2i = Vector2i(1, 1)
	maze[pos.y][pos.x] = false
	stack.push_back(pos)

	var directions: Array[Vector2i] = [Vector2i(2, 0), Vector2i(-2, 0), \
									   Vector2i(0, 2), Vector2i(0, -2)]

	while not stack.is_empty():
		pos = stack.back()
		var options: Array[Vector2i] = []

		for dir: Vector2i in directions:
			var nx: int = pos.x + dir.x
			var ny: int = pos.y + dir.y
			if nx > 0 and ny > 0 and nx < width - 1 and \
									 ny < height - 1 and maze[ny][nx]:
				options.append(dir)

		if options:
			var chosen: Vector2i = options[randi() % options.size()]
			var between: Vector2i = pos + chosen / 2
			var next: Vector2i = pos + chosen
			maze[between.y][between.x] = false
			maze[next.y][next.x] = false
			stack.push_back(next)
		else:
			stack.pop_back()

	var wall_mesh: BoxMesh = BoxMesh.new()
	wall_mesh.size = Vector3(cell_size, wall_height, cell_size)

	for y: int in range(height):
		for x: int in range(width):
			if maze[y][x]:
				var wall: MeshInstance3D = MeshInstance3D.new()
				wall.mesh = wall_mesh
				wall.position = Vector3.ZERO

				var wall_body: StaticBody3D = StaticBody3D.new()
				wall_body.position = Vector3(x * cell_size, \
											 wall_height / 2.0, y * cell_size)

				var collision: CollisionShape3D = CollisionShape3D.new()
				var box_shape: BoxShape3D = BoxShape3D.new()
				box_shape.size = Vector3(cell_size, wall_height, cell_size)
				collision.shape = box_shape

				wall_body.add_child(wall)
				wall_body.add_child(collision)
				add_child(wall_body)

func generate_floor() -> void:
	var floor_box_mesh: BoxMesh = BoxMesh.new()
	floor_box_mesh.size = Vector3(cell_size, 1.0, cell_size)

	for y: int in range(height):
		for x: int in range(width):
			if not maze[y][x]:
				var pos: Vector3 = Vector3(x * cell_size, 0.0, y * cell_size)

				var floor_mesh: MeshInstance3D = MeshInstance3D.new()
				floor_mesh.mesh = floor_box_mesh
				floor_mesh.position = Vector3.ZERO

				var floor_body: StaticBody3D = StaticBody3D.new()
				floor_body.position = pos

				var collision: CollisionShape3D = CollisionShape3D.new()
				var box_shape: BoxShape3D = BoxShape3D.new()
				box_shape.size = Vector3(cell_size, 1.0, cell_size)
				collision.shape = box_shape

				floor_body.add_child(floor_mesh)
				floor_body.add_child(collision)
				add_child(floor_body)

func place_player() -> void:
	var player: CharacterBody3D = get_parent().get_node("Player")
	for y: int in range(height):
		for x: int in range(width):
			if not maze[y][x]:
				player.global_position = Vector3(x * cell_size, \
										 wall_height + 1, y * cell_size)
				return

func place_exit() -> void:
	for y: int in range(height - 1, 0, -1):
		for x: int in range(width - 1, 0, -1):
			if not maze[y][x]:
				var exit: MeshInstance3D = MeshInstance3D.new()
				var mesh: BoxMesh = BoxMesh.new()
				mesh.size = Vector3(2, 2, 2)
				exit.mesh = mesh
				exit.position = Vector3(x * cell_size, 3.0, y * cell_size)

				var mat: StandardMaterial3D = StandardMaterial3D.new()
				mat.albedo_color = Color(1.0, 0.0, 0.0)
				mesh.material = mat

				add_child(exit)
				return
