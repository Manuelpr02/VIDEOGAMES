extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -320.0
const CAIDA_LIMITE = 1000.0 

# --- AJUSTES DE HIELO ---
const FRICCION_HIELO = 2.0  # Menor valor = más deslizamiento al soltar teclas
const ACELERACION_HIELO = 3.0 # Menor valor = más tiempo para alcanzar velocidad máxima
const FRICCION_NORMAL = 50.0 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D 

func _ready():
	# Teletransporta a Santa al checkpoint guardado si existe uno
	if GameManager.posicion_checkpoint != Vector2.ZERO:
		global_position = GameManager.posicion_checkpoint
		velocity = Vector2.ZERO

func rebotar():
	# Función llamada por enemigos cuando Santa los pisa desde arriba
	velocity.y = -350.0 

func _physics_process(delta):
	# Seguridad: No procesar si el nodo se está eliminando
	if not is_inside_tree():
		return

	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 2. Sistema de Abismo (Caída al vacío)
	if position.y > CAIDA_LIMITE:
		perder_por_caida()
		return

	# 3. Manejar Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 4. Movimiento Lateral e Interacción con Suelo
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Detectar si el suelo actual es una superficie resbaladiza (Hielo/Barra)
	var esta_en_hielo = false
	if is_on_floor():
		for i in get_slide_collision_count():
			var colision = get_slide_collision(i)
			if "Barra" in colision.get_collider().name:
				esta_en_hielo = true

	if direction:
		# Si hay movimiento: aplicar aceleración suave en hielo o instantánea en suelo normal
		if esta_en_hielo:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACELERACION_HIELO)
		else:
			velocity.x = direction * SPEED
		
		# Animación visual: voltear sprite y balanceo al caminar
		sprite.flip_h = direction < 0
		if is_on_floor():
			sprite.rotation = sin(Time.get_ticks_msec() * 0.01) * 0.05
			sprite.offset.y = 0 
	else:
		# Si no hay teclas pulsadas: aplicar fricción para detenerse
		var friccion = FRICCION_NORMAL
		if esta_en_hielo:
			friccion = FRICCION_HIELO
		
		velocity.x = move_toward(velocity.x, 0, friccion)
		
		# Animación de "respiración" (flotación leve) cuando está quieto
		if is_on_floor():
			sprite.rotation = move_toward(sprite.rotation, 0, 0.01)
			sprite.offset.y = sin(Time.get_ticks_msec() * 0.005) * 4 

	# Ejecuta el movimiento físico final
	move_and_slide()

func perder_por_caida():
	# Detiene el script y avisa al GameManager para reiniciar el nivel
	set_physics_process(false)
	if GameManager.has_method("perder_vida"):
		GameManager.perder_vida()
