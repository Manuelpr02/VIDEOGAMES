extends CharacterBody2D

var speed = 375 # Velocidad de movimiento de la pala

func _physics_process(delta):
	# Reinicia la velocidad a 0 en cada frame para que no se mueva sola
	velocity.y = 0
	
	# Si presionas la flecha hacia arriba, la dirección es -1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	# Si presionas la flecha hacia abajo, la dirección es 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1 
	
	# Multiplica la dirección por la velocidad configurada
	velocity.y *= speed
	
	# Mueve la pala y detecta si choca con los límites (paredes)
	move_and_collide(velocity * delta)
