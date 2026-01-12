extends CharacterBody2D

var speed = 400.0             # Velocidad de la pelota
var is_active = true          # Controla si la pelota se mueve o está quieta
var tiene_punto_jugador = false # Indica si la pelota está "cargada" para romper bloques

# Se ejecuta al iniciar el juego
func _ready():
	# Le da una dirección inicial a la pelota
	velocity = Vector2(200, speed)

# Se ejecuta en cada frame de física
func _physics_process(delta):
	# Si la pelota no está activa, no hace nada
	if not is_active: return
	
	# Mueve la pelota y detecta si choca con algo
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		# Rebota la pelota según el ángulo del choque
		velocity = velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()
		
		# Si choca con tu pala, se activa (se pone brillante)
		if collider.name == "Paddle":
			tiene_punto_jugador = true
			modulate = Color(1, 1, 1)
			
		# Si toca el fondo, se desactiva (se pone oscura)
		elif collider.name == "Ceiling" or collider.name == "Ceiling2":
			tiene_punto_jugador = false
			modulate = Color(0.3, 0.3, 0.3)
			
		# Si choca con un bloque (ladrillo)
		if collider.has_method("hit"):
			# Solo lo rompe si viene de tocar tu pala
			if tiene_punto_jugador:
				collider.hit() 
				# Tras romperlo, se descarga para que no rompa el siguiente sin tocar la pala
				tiene_punto_jugador = false
			else:
				# Si no está cargada, rebota normalmente sin romper
				pass
