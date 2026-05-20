extends Node2D

func _ready():
	# 1. Recupera el control del puntero para navegar por la interfaz
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# 2. Busca el nodo LabelPuntos de forma recursiva en la escena
	var label = find_child("LabelPuntos", true, false)
	
	if label:
		# Muestra la puntuación final acumulada en el Singleton GameManager
		label.text = "¡ Total de puntos por regalos:  "+ str(GameManager.coleccionables_totales) + " !"
	else:
		# Aviso de depuración por si el nodo fue renombrado en el Inspector
		print("Error: No encontré 'LabelPuntos'. Verifica que el nombre sea exacto.")

# Se activa al pulsar el botón de reiniciar/volver al inicio
func _on_button_pressed() -> void:
	# 3. HARD RESET: Limpieza absoluta del estado del juego
	# Es vital vaciar estas variables para que la siguiente partida empiece de cero
	GameManager.coleccionables_totales = 0
	GameManager.puntos_nivel_anterior = 0
	GameManager.vidas = 5
	GameManager.coleccionables_recogidos.clear()
	GameManager.posicion_checkpoint = Vector2.ZERO
	GameManager.nivel_actual_nombre = ""
	
	# 4. Retorno a la pantalla de título
	get_tree().change_scene_to_file("res://Niveles/pantalla_inicial.tscn")
