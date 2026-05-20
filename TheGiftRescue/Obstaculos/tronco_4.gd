extends AnimatableBody2D

# Configuración ajustable desde el editor
@export var distancia: float = 270.0 # Recorrido vertical en píxeles
@export var tiempo: float = 3        # Segundos que tarda en completar cada tramo

func _ready():
	# Crea una animación infinita (.set_loops) con suavizado senoidal (.TRANS_SINE)
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Primer paso: Sube (restar en el eje Y mueve el objeto hacia arriba en Godot)
	tween.tween_property(self, "position:y", position.y - distancia, tiempo)
	
	# Segundo paso: Baja (vuelve a la posición Y original del nodo)
	tween.tween_property(self, "position:y", position.y, tiempo)
