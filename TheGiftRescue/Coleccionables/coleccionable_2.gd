extends Area2D

var tiempo : float = 0.0
var posicion_inicial : Vector2
@export var amplitud : float = 8.0  # Rango del movimiento vertical
@export var velocidad_flotacion : float = 4.0  # Rapidez del balanceo

func _ready():
	# Si el objeto ya se recogió (según su nombre), se elimina al empezar
	if GameManager.coleccionables_recogidos.has(name):
		queue_free()
		return 
	
	posicion_inicial = position
	# Detecta cuando Santa entra en el área
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Calcula el movimiento de flotación usando una onda senoidal
	tiempo += delta * velocidad_flotacion
	position.y = posicion_inicial.y + sin(tiempo) * amplitud

func _on_body_entered(body):
	# Si es Santa, suma 2 al contador y elimina el objeto
	if body.name == "Santa":
		GameManager.sumar_coleccionable(2, name)
		queue_free()
