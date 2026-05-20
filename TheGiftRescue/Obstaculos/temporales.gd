extends AnimatableBody2D  # Necesario para que Santa se mueva junto con la plataforma

@export var velocidad: float = 100.0
@onready var sprite = $Sprite2D
@onready var colision = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	# Conecta la señal del Timer para ejecutar la lógica cada vez que el tiempo termine
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	# Alterna el estado de la plataforma basándose en la visibilidad del sprite
	if sprite.visible:
		desaparecer()
	else:
		aparecer()

func aparecer():
	sprite.show() # Hace visible la plataforma
	# Habilita la colisión de forma segura para las físicas de Godot
	colision.set_deferred("disabled", false)

func desaparecer():
	sprite.hide() # Oculta la plataforma
	# Deshabilita la colisión para que los objetos la atraviesen
	colision.set_deferred("disabled", true)
