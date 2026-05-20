extends AnimatableBody2D

@export var distancia: float = 80.0  # Píxeles de recorrido
@export var tiempo: float = 1.0      # Duración del movimiento

func _ready():
	# Inicia animación infinita con transición suave (senoidal)
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Baja: suma a la Y (hacia abajo en Godot)
	tween.tween_property(self, "position:y", position.y + distancia, tiempo)
	
	# Sube: regresa a la coordenada Y inicial
	tween.tween_property(self, "position:y", position.y, tiempo)
