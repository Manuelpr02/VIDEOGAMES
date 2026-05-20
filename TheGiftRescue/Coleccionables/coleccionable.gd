extends Area2D

var tiempo : float = 0.0
var posicion_inicial : Vector2
@export var amplitud : float = 8.0  # Qué tanto sube y baja (píxeles)
@export var velocidad_flotacion : float = 4.0  # Rapidez del balanceo

func _ready():
	# Si el objeto ya fue recogido antes (según el GameManager), se elimina
	if GameManager.coleccionables_recogidos.has(name):
		queue_free()
		return
	
	posicion_inicial = position
	# Conecta la detección de colisión
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Crea un movimiento oscilatorio suave usando la función seno (sin)
	tiempo += delta * velocidad_flotacion
	position.y = posicion_inicial.y + sin(tiempo) * amplitud

func _on_body_entered(body):
	# Si Santa toca el objeto, suma el punto y lo elimina de la escena
	if body.name == "Santa":
		GameManager.sumar_coleccionable(1, name)
		queue_free()
