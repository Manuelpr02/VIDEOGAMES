extends CharacterBody2D

var speed: float = 100.0
var player: Node2D = null
var BalaEscena: PackedScene = preload("res://bala.tscn") # Cargamos la misma bala

@onready var timer = $Timer
@onready var boquilla = $Boquilla

func _ready() -> void:
	player = get_tree().root.find_child("Jugador", true, false)
	# Conectamos el temporizador para que dispare
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(_delta: float) -> void:
	if player:
		# Orientarse siempre al jugador
		look_at(player.global_position)
		rotation += deg_to_rad(90) # Ajuste según tu sprite

		# Persecución suave
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_timer_timeout() -> void:
	if player:
		disparar()

func disparar() -> void:
	var bala = BalaEscena.instantiate()
	bala.disparado_por_ia = true 
	
	bala.position = boquilla.global_position
	bala.rotation = rotation
	get_tree().root.add_child(bala)
