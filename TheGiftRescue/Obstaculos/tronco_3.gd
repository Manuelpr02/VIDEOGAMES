extends AnimatableBody2D

# Variables configurables desde el editor de Godot
@export var distancia: float = 270.0 # Altura total del recorrido
@export var tiempo: float = 2.0      # Duración (en segundos) de la subida y de la bajada

func _ready():
	# Inicializa el Tween: .set_loops() lo hace infinito y .set_trans(Tween.TRANS_SINE) suaviza el movimiento
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Primera fase: Sube restando la distancia a la posición Y actual
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Segunda fase: Baja regresando exactamente a la posición Y original
	tween.tween_property(self, "position:y", position.y, tiempo)
