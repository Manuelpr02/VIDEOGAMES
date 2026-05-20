extends AnimatableBody2D

@export var distancia: float = 200.0  # Distancia del recorrido en píxeles
@export var tiempo: float = 0.9       # Tiempo que tarda en ir (o volver)

func _ready():
	# Crea una transición infinita con movimiento suavizado (SINE)
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Mueve hacia la DERECHA (suma a la X)
	tween.tween_property(self, "position:x", position.x + distancia, tiempo)
	
	# Regresa a la IZQUIERDA (vuelve a la posición inicial)
	tween.tween_property(self, "position:x", position.x, tiempo)
