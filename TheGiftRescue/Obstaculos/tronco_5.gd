extends AnimatableBody2D

@export var distancia: float = 80.0  # Altura del desplazamiento en píxeles
@export var tiempo: float = 1.0      # Duración de cada fase del trayecto

func _ready():
	# Crea una animación infinita con una curva senoidal (suave al inicio y fin)
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Fase 1: Sube (en Godot, restar en Y mueve el objeto hacia arriba)
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Fase 2: Baja (regresa a la coordenada Y donde empezó)
	tween.tween_property(self, "position:y", position.y, tiempo)
