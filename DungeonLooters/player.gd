extends CharacterBody2D

@export var speed: float = 100.0
@onready var misil_scene = preload("res://misil.tscn")
@onready var mira_pivot = $MiraPivot 

var coins: int = 0
var is_shooting: bool = false
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false

# --- NUEVAS VARIABLES PARA VIDAS ---
var start_position: Vector2
var is_invincible: bool = false

func _ready():
	# Guardamos la posición donde empieza el nivel para el Respawn
	start_position = global_position
	target_position = global_position
	
	# Conectamos la señal de muerte del Global para saber cuándo reaparecer
	GameEvents.player_died.connect(_on_player_died)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if mira_pivot:
		mira_pivot.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("click_izquierdo"):
		target_position = get_global_mouse_position()
		is_moving = true

	if Input.is_action_just_pressed("ui_accept") and not is_shooting:
		shoot()

	handle_movement()

func handle_movement():
	if is_moving and not is_shooting:
		var distance_to_target = global_position.distance_to(target_position)
		if distance_to_target > 5:
			var direction = (target_position - global_position).normalized()
			velocity = direction * speed
			$AnimatedSprite2D.play("run")
			if velocity.x != 0:
				$AnimatedSprite2D.flip_h = velocity.x < 0
			move_and_slide()
		else:
			stop_movement()
	elif not is_shooting:
		$AnimatedSprite2D.play("default")

func stop_movement():
	velocity = Vector2.ZERO
	is_moving = false
	$AnimatedSprite2D.play("default")

func shoot():
	is_shooting = true
	$AnimatedSprite2D.play("shoot")
	var misil = misil_scene.instantiate()
	
	if has_node("MiraPivot/Sprite2D"):
		misil.global_position = $MiraPivot/Sprite2D.global_position
	else:
		misil.global_position = global_position 
	
	var mouse_dir = (get_global_mouse_position() - global_position).normalized()
	misil.direction = mouse_dir
	misil.rotation = mouse_dir.angle()
	
	get_parent().add_child(misil)
	await $AnimatedSprite2D.animation_finished
	is_shooting = false

# --- LÓGICA DE DAÑO Y RESPOND ---

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("¡COLISIÓN DETECTADA CON: ", body.name, "!") # Esto debería salir siempre al chocar
	
	if body.is_in_group("enemies"):
		print("El objeto SI es del grupo 'enemies'")
		if not is_invincible:
			recibir_daño()
	else:
		print("El objeto NO es del grupo 'enemies'. Grupos del objeto: ", body.get_groups())

func recibir_daño():
	# Si ya somos invencibles, no hacemos nada para evitar bucles
	if is_invincible:
		return
		
	is_invincible = true
	GameEvents.lose_health() # Esto resta la vida en el Global
	
	# Solo si seguimos vivos después de perder salud, hacemos el parpadeo
	# Si GameEvents detecta que vidas == 0, emitirá 'player_died' por su cuenta
	if GameEvents.current_health > 0:
		aplicar_efecto_parpadeo()

func _on_player_died():
	# 1. Teletransporte
	global_position = start_position
	target_position = start_position
	stop_movement()
	
	# 2. Reset de estado para evitar que muera en bucle
	is_invincible = true 
	
	# 3. Efecto visual de parpadeo directamente, SIN llamar a recibir_daño()
	aplicar_efecto_parpadeo()

# He creado esta función aparte para que ambos puedan usarla sin llamarse entre sí
func aplicar_efecto_parpadeo():
	var tween = create_tween()
	tween.set_loops(5)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0.2), 0.2)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 1), 0.2)
	await tween.finished
	is_invincible = false

func add_coin():
	coins += 1
	GameEvents.coin_collected.emit(coins)
