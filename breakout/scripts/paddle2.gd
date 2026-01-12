extends CharacterBody2D

const SPEED = 500.0    # Velocidad a la que se mueve la IA
var direction = 1      # Dirección inicial (1 es derecha, -1 es izquierda)

func _physics_process(delta: float) -> void:
	# Aplica la velocidad constante en el eje X
	velocity.x = direction * SPEED
	
	# Mueve la pala y gestiona las colisiones
	move_and_slide()
	
	# Si choca contra una pared lateral, cambia la dirección al lado contrario
	if is_on_wall():
		direction *= -1
		
	# Mantiene la pala siempre a la misma altura (50 píxeles desde arriba)
	global_position.y = 50
