extends Area2D

var tiempo : float = 0.0
var posicion_inicial : Vector2
@export var amplitud : float = 8.0  # Altura del balanceo
@export var velocidad_flotacion : float = 4.0  # Rapidez del movimiento

func _ready():
	# Si ya fue recogido (chequeo por nombre), desaparece de inmediato
	if GameManager.coleccionables_recogidos.has(name):
		queue_free()
		return 
	
	posicion_inicial = position
	# Conecta la señal para detectar colisiones con Santa
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Incrementa el tiempo para la función seno
	tiempo += delta * velocidad_flotacion
	# Aplica el movimiento de flotación vertical
	position.y = posicion_inicial.y + sin(tiempo) * amplitud

func _on_body_entered(body):
	# Si Santa entra en el área, suma 3 coleccionables y borra el objeto
	if body.name == "Santa":
		GameManager.sumar_coleccionable(3, name)
		queue_free()
