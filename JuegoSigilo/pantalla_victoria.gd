extends Control

@onready var label_puntos = $ResultadoPuntos
@onready var label_tiempo = $ResultadoTiempo

func _ready():
	# Leemos los datos de la "mochila" Global
	label_puntos.text = "Banderas totales conseguidas: " + str(Global.puntos_finales)
	label_tiempo.text = "Tiempo final: " + Global.tiempo_final
# Esta función se ejecutará cuando pulsemos el botón
func _on_boton_reiniciar_pressed():
	# 1. Opcional: Si quieres resetear los puntos globales al empezar
	Global.puntos_finales = 0
	Global.tiempo_final = "00:00"
	
	# 2. Cambiamos de nuevo a la escena del nivel (ajusta la ruta a tu nivel)
	get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_button_pressed() -> void:
	get_tree().quit()# Replace with function body.
