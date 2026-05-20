extends AnimatableBody2D

@export var distancia: float = 80.0  # Rango del movimiento en píxeles
@export var tiempo: float = 1.0      # Segundos que tarda en desplazarse

func _ready():
	# Crea el Tween, lo hace infinito y con curvas de movimiento suaves
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Primer paso: Desplaza el objeto hacia arriba (Y negativa)
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Segundo paso: Regresa el objeto a su posición Y inicial
	tween.tween_property(self, "position:y", position.y, tiempo)
