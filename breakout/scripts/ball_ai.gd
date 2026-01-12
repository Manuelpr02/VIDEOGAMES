extends CharacterBody2D

var speed = 400.0             # Velocidad de la pelota
var is_active = true          # Controla si la pelota se mueve
var tiene_punto_ia = false    # Indica si la IA puede romper bloques ahora

# Configuración inicial
func _ready():
	# Dirección inicial (hacia arriba y a la izquierda)
	velocity = Vector2(-200, -speed)

# Cálculo de física cada frame
func _physics_process(delta):
	# Si está pausada, no hace nada
	if not is_active: return
	
	# Detecta colisiones mientras se mueve
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Rebota al chocar
		velocity = velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()
		
		# Si toca la pala de la IA, se "carga" (brilla)
		if collider.name == "Paddle2":
			tiene_punto_ia = true
			modulate = Color(1, 1, 1)
			
		# Si toca el fondo, pierde la carga (se oscurece)
		elif collider.name == "Ceiling" or collider.name == "Ceiling2":
			tiene_punto_ia = false
			modulate = Color(0.3, 0.3, 0.3)
			
		# Lógica para romper ladrillos
		if collider.has_method("hit_by_ai"):
			if tiene_punto_ia:
				collider.hit_by_ai() # Rompe el bloque
				tiene_punto_ia = false # Pierde la carga tras el golpe
			else:
				# Solo rebota si no está cargada
				pass
