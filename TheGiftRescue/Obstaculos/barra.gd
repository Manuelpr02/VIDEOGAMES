extends AnimatableBody2D

@export var distancia: float = 100.0 # Píxeles a recorrer
@export var tiempo: float = 2.0      # Segundos por trayecto

func _ready():
	# Configura el movimiento infinito y con suavidad senoidal
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Sube (resta distancia a la posición Y actual)
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Baja (vuelve a la posición Y original)
	tween.tween_property(self, "position:y", position.y, tiempo)
