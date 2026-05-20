extends Label

func _process(_delta: float) -> void:
	# Accedemos directamente al Autoload
	text = "Tiempo: " + GlobalTimer.get_time_string()
