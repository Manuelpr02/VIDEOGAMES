extends CharacterBody3D

# Variables de salud según el manual [cite: 24]
var health: float = 100.0
var max_health: float = 100.0
var apples_collected: int = 0

# Configuración de movimiento y disparo [cite: 17, 18]
@export var speed: float = 5.0
@export var rotation_speed: float = 10.0
var target_position: Vector3

func _ready():
	add_to_group("player") # Necesario para que las manzanas te reconozcan
	target_position = global_position

func _input(event):
	# Movimiento con clic derecho 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_update_target_position()
		
	# Disparo con clic izquierdo 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_shoot()

func _physics_process(delta: float) -> void:
	# 1. Recuperación pasiva: 10 PV cada 5 seg (2 PV por segundo) 
	health = min(max_health, health + (2.0 * delta))
	
	# 2. Gravedad básica
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 3. Lógica de movimiento hacia el clic 
	if global_position.distance_to(target_position) > 0.5:
		var direction = (target_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Rotar suavemente hacia la dirección del movimiento
		var look_target = Vector3(target_position.x, global_position.y, target_position.z)
		if global_position.distance_to(look_target) > 0.1:
			var target_basis = Basis.looking_at(look_target - global_position)
			basis = basis.slerp(target_basis, rotation_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _update_target_position():
	# Proyectar un rayo desde la cámara al suelo para saber dónde hicimos clic
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 100
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)
	
	if result:
		target_position = result.position

func _shoot():
	# 1. Verificar si el RayCast está tocando algo
	if $RayCast3D.is_colliding():
		var objetivo = $RayCast3D.get_collider()
		
		# 2. Comprobar si es un enemigo [cite: 19]
		if objetivo.is_in_group("enemy"):
			# 3. Aplicar los 10 de daño reglamentarios 
			if "health" in objetivo:
				objetivo.health -= 10
				print("¡Impacto! Vida del enemigo: ", objetivo.health)
				
				# Opcional: Si el enemigo muere
				if objetivo.health <= 0:
					print("Enemigo derrotado")
					# Aquí podrías llamar a una función de muerte del enemigo

# Variables necesarias
const TOTAL_APPLES: int = 3

func collect_apple():
	apples_collected += 1
	print("Manzanas recogidas: ", apples_collected) 
	
	if apples_collected >= TOTAL_APPLES:
		show_victory_message()
@export var win_label: Label
func show_victory_message():
	if win_label:
		win_label.visible = true
		print("Victoria: 3 manzanas recogidas")
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
