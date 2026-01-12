extends CharacterBody2D

const SPEED = 1000.0  # Velocidad máxima de movimiento de tu pala

func _physics_process(delta: float) -> void:
	# Detecta si presionas las flechas izquierda o derecha (o A y D)
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		# Si hay dirección, aplica la velocidad hacia ese lado
		velocity.x = direction * SPEED
	else:
		# Si sueltas las teclas, frena la pala suavemente hasta detenerla
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Aplica el movimiento y gestiona el choque con las paredes laterales
	move_and_slide()
