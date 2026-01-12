extends CharacterBody2D

var speed = 375   # Velocidad de movimiento de la IA
var ball          # Variable para guardar la referencia a la pelota

# Se ejecuta al iniciar
func _ready():
	# Busca el nodo de la pelota en la escena para saber dónde está
	ball = get_parent().get_node("Ball")
	
# Control de movimiento en cada frame
func _physics_process(delta):
	# Si la pelota está muy cerca de la misma altura (Y), se queda quieta
	# Esto evita que la pala tiemble cuando está alineada
	if abs(ball.position.y - position.y) < 10:
		return
	
	# Si la pelota está más arriba que la pala, se mueve hacia arriba
	if ball.position.y < position.y:
		velocity.y = -1
	# Si la pelota está más abajo, se mueve hacia abajo
	else:
		velocity.y = 1
		
	# Multiplica la dirección (1 o -1) por su velocidad
	velocity *= speed
	
	# Mueve la pala y detecta choques
	move_and_collide(velocity * delta)
