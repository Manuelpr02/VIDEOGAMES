extends CharacterBody3D

# Definición de estados según el esquema de la IA [cite: 3]
enum EnemyState { PATROL, ATTACK, ESCAPE, HEALING }
var current_state = EnemyState.PATROL

# Atributos de salud [cite: 24]
var health = 100.0
@export var target: CharacterBody3D # Jugador azul [cite: 15]
@export var patrol_points: Array[Marker3D] # Zona asignada [cite: 20]
@export var potion_area: Marker3D # Zona de pócimas púrpuras [cite: 21]

@onready var agent = $NavigationAgent3D

func _physics_process(delta):
	# Recuperación pasiva: 10 PV cada 5 segundos (2 PV por segundo) 
	health = min(100, health + (2.0 * delta))
	
	match current_state:
		EnemyState.PATROL:
			_patrol()
		EnemyState.ATTACK:
			_attack()
		EnemyState.ESCAPE:
			_escape()
		EnemyState.HEALING:
			_healing()
	
	_move_logic(delta)

func _patrol():
	# El enemigo patrulla su zona asignada [cite: 20]
	if patrol_points.size() > 0:
		agent.target_position = patrol_points[0].global_position
	
	# Si el jugador está cerca, cambia a ataque [cite: 9]
	if global_position.distance_to(target.global_position) < 7.0:
		current_state = EnemyState.ATTACK

func _attack():
	# Persigue al jugador activamente [cite: 10, 20]
	agent.target_position = target.global_position
	
	# Transiciones por salud o distancia:
	if health < 25: # Vida < 25% inicia la huida [cite: 3]
		current_state = EnemyState.ESCAPE
	elif global_position.distance_to(target.global_position) > 12.0: # Jugador lejos [cite: 11]
		current_state = EnemyState.PATROL

func _escape():
	# El enemigo escapa hacia la zona de pócimas [cite: 4, 6]
	agent.target_position = potion_area.global_position
	
	# Si llega a la zona, espera o busca sanarse [cite: 2, 6]
	if agent.is_navigation_finished():
		current_state = EnemyState.HEALING

func _healing():
	# Si no hay pócimas disponibles, se queda esperando en la zona [cite: 6]
	# Una vez que la vida es >= 50%, vuelve a patrullar [cite: 7]
	if health >= 50: 
		current_state = EnemyState.PATROL

# Función que debe llamar la Pócima (Area3D) al detectar a la IA
func heal_completely():
	health = 100.0 # Recupera toda su vida al tomar la pócima 
	print("IA sanada completamente")

func _move_logic(delta):
	if not agent.is_navigation_finished():
		var next_pos = agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * 3.0
		move_and_slide()
