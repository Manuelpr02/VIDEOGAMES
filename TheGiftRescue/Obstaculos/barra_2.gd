extends AnimatableBody2D

@export var distancia: float = 100.0 # Píxeles de desplazamiento
@export var tiempo: float = 2.0      # Segundos por trayecto

func _ready():
	# Crea el animador, lo hace infinito y suaviza el movimiento
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Sube: resta distancia a la Y (hacia arriba en Godot)
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Baja: vuelve a la posición inicial en Y
	tween.tween_property(self, "position:y", position.y, tiempo)
