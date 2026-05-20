extends Node

var time_elapsed: float = 0.0
var is_active: bool = false # <--- Cambiado a false por defecto

func _process(delta: float) -> void:
	if is_active:
		time_elapsed += delta

# Función para limpiar el tiempo cuando volvemos al menú o reiniciamos
func reset_timer() -> void:
	time_elapsed = 0.0
	is_active = false

func get_time_string() -> String:
	var minutes: int = int(time_elapsed) / 60
	var seconds: int = int(time_elapsed) % 60
	return "%02d:%02d" % [minutes, seconds]
