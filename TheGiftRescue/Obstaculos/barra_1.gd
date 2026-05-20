extends AnimatableBody2D

@export var velocidad: float = 300.0
@export var distancia: float = 200.0

var posicion_inicial: Vector2
var direccion: int = 1 # 1 para derecha, -1 para izquierda

func _ready():
	# Guarda la posición donde empieza el objeto
	posicion_inicial = global_position

func _physics_process(delta):
	# Movimiento horizontal constante basado en dirección y tiempo
	position.x += velocidad * delta * direccion
	
	# Límite derecho: si supera la distancia, ajusta posición y cambia dirección
	if position.x > posicion_inicial.x + distancia:
		position.x = posicion_inicial.x + distancia 
		direccion = -1 
		
	# Límite izquierdo: si baja del rango, ajusta posición y cambia dirección
	elif position.x < posicion_inicial.x - distancia:
		position.x = posicion_inicial.x - distancia 
		direccion = 1
