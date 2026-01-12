extends CharacterBody2D

var speed = 400 # Velocidad de la pelota

# Se ejecuta al iniciar
func _ready():
	set_ball_velocity() # Llama a la función para lanzar la pelota
	
# Configura la dirección inicial de forma aleatoria
func set_ball_velocity():
	# Elige al azar si sale hacia la derecha (1.2) o izquierda (-1.2)
	if randi() % 2 == 0:
		velocity.x = 1.2
	else:
		velocity.x = -1.2
		
	# Elige al azar si sale hacia abajo (1) o hacia arriba (-1)
	if randi() % 2 == 0:
		velocity.y = 1
	else:
		velocity.y = -1
		
	# Multiplica la dirección por la velocidad para que se mueva rápido
	velocity *= speed
	
# Control de movimiento y choques
func _physics_process(delta):
	# Mueve la pelota y guarda información si choca con algo
	var collision_info = move_and_collide(velocity * delta)
	
	# Si hubo un choque, rebota la pelota automáticamente
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
