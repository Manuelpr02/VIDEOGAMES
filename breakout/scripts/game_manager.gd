extends Node

# Variables globales para los puntos y el nivel actual
var score_player = 0
var score_ai = 0
var level = 1 

# Función para sumar puntos al Jugador
func addPointsPlayer(points):
	score_player += points
	print("Jugador suma: ", score_player) # Muestra los puntos en la consola
	update_ui() # Actualiza los textos en pantalla

# Función para sumar puntos a la IA
func addPointsAI(points):
	score_ai += points
	print("IA suma: ", score_ai)
	update_ui() # Actualiza los textos en pantalla

# Se ejecuta al arrancar el juego
func _ready() -> void:
	# Espera un instante para asegurar que la pantalla cargó
	await get_tree().process_frame
	update_ui() # Dibuja los textos iniciales

# Función para actualizar los textos (Labels) de la interfaz
func update_ui():
	# Busca los nodos de texto por su nombre en la escena
	var label_p = find_child("ScoreLabel", true, false)
	var label_ai = find_child("AIScoreLabel", true, false)
	var label_lvl = find_child("LevelLabel", true, false)
	
	# Si encuentra el texto del Jugador, actualiza su valor
	if label_p:
		label_p.text = "Tú: " + str(score_player)
	
	# Si encuentra el de la IA, lo actualiza
	if label_ai:
		label_ai.text = "IA: " + str(score_ai)
	
	# Si encuentra el del Nivel, lo actualiza
	if label_lvl:
		label_lvl.text = "Nivel: " + str(level)
	else:
		# Intento extra: busca el texto directamente en la escena actual si falla lo anterior
		var scene_label = get_tree().current_scene.find_child("ScoreLabel", true, false)
		if scene_label:
			scene_label.text = "Tú: " + str(score_player)
