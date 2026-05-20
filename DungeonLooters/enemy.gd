extends CharacterBody2D

enum State { WANDER, CHASE, ATTACK }
var current_state = State.WANDER

@export_group("IA y Movimiento")
@export var speed: float = 30.0
@export var chase_speed: float = 90.0
@export var attack_distance: float = 40.0

var move_direction: Vector2 = Vector2.ZERO
var player: Node2D = null

func _ready() -> void:
	# Aseguramos que el enemigo esté en el grupo para el sistema de muerte/respawn
	add_to_group("enemies")
	
	# Conexiones
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)
	$AnimatedSprite2D.animation_finished.connect(_on_anim_finished)
	$ChangeDirTimer.timeout.connect(_on_timer_timeout)
	
	# INICIALIZACIÓN CRÍTICA
	_change_state(State.WANDER)
	_play_anim("walk") # Forzamos que empiece la animación desde el frame 1

func _physics_process(_delta: float) -> void:
	match current_state:
		State.WANDER:
			_logic_wander()
		State.CHASE:
			_logic_chase()
		State.ATTACK:
			_logic_attack()

# --- LÓGICA DE LOS ESTADOS ---

func _logic_wander() -> void:
	velocity = move_direction * speed
	_play_anim("walk")
	
	if move_direction.x != 0:
		$AnimatedSprite2D.flip_h = move_direction.x < 0
		
	if move_and_slide():
		choose_random_direction()

func _logic_chase() -> void:
	if not player:
		_change_state(State.WANDER)
		return

	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	
	$AnimatedSprite2D.flip_h = direction.x < 0
	
	if distance <= attack_distance:
		_change_state(State.ATTACK)
	else:
		velocity = direction * chase_speed
		_play_anim("walk")
		move_and_slide()

func _logic_attack() -> void:
	velocity = Vector2.ZERO

# --- CONTROLADOR DE CAMBIO DE ESTADO ---

func _change_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.WANDER:
			choose_random_direction()
		State.CHASE:
			pass
		State.ATTACK:
			$AnimatedSprite2D.play("attack")

# --- FUNCIONES DE APOYO Y SEÑALES ---

func choose_random_direction() -> void:
	var random_angle = randf_range(0, 2 * PI)
	move_direction = Vector2.RIGHT.rotated(random_angle)

func _play_anim(anim_name: String) -> void:
	# Si la animación es distinta, la cambiamos
	if $AnimatedSprite2D.animation != anim_name:
		$AnimatedSprite2D.play(anim_name)
	
	# REFUERZO: Si por alguna razón la animación está pausada (sprite pillado),
	# le damos al play para que siga su curso.
	if not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		_change_state(State.CHASE)

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		_change_state(State.WANDER)

func _on_anim_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		_change_state(State.CHASE)

func _on_timer_timeout() -> void:
	if current_state == State.WANDER:
		choose_random_direction()
