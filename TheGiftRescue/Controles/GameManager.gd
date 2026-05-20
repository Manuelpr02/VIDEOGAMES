extends Node

var coleccionables_totales : int = 0
var puntos_nivel_anterior : int = 0 
signal actualizar_marcador # Señal para avisar a otros nodos de cambios en puntos

var vidas : int = 5 
var interfaz_corazones : HBoxContainer 
var posicion_checkpoint : Vector2 = Vector2.ZERO
var coleccionables_recogidos = [] # Lista para evitar recoger el mismo objeto dos veces
var nivel_actual_nombre : String = ""

func iniciar_nuevo_nivel(nombre_escena: String):
	# Si reinicia nivel por morir, resetea puntos al valor que tenía al empezar el nivel
	if nivel_actual_nombre == nombre_escena:
		coleccionables_totales = puntos_nivel_anterior
	else:
		# Si es un nivel nuevo, guarda progreso y limpia lista de objetos recogidos
		nivel_actual_nombre = nombre_escena
		puntos_nivel_anterior = coleccionables_totales
		coleccionables_recogidos.clear() 

func sumar_coleccionable(cantidad: int, id_nombre: String):
	# Solo suma si el ID del objeto no está en la lista de "ya recogidos"
	if not coleccionables_recogidos.has(id_nombre):
		coleccionables_recogidos.append(id_nombre)
		coleccionables_totales += cantidad
		actualizar_marcador.emit()
		
		# Actualiza el texto del HUD buscando el nodo "Label" en la escena actual
		var label = get_tree().current_scene.find_child("Label", true, false)
		if label:
			label.text = "Puntos por regalo: " + str(coleccionables_totales)

func perder_vida():
	vidas -= 1
	actualizar_hud_corazones()
	
	var santa = get_tree().current_scene.find_child("Santa", true, false)
	if santa:
		santa.set_physics_process(false) 

	var ruta_escena = get_tree().current_scene.scene_file_path
	
	if vidas > 0:
		get_tree().change_scene_to_file(ruta_escena)
	else:
		# --- SECCIÓN MODIFICADA: GAME OVER ---
		vidas = 5
		
		# En lugar de 0, volvemos a los puntos que tenías al entrar a este nivel
		coleccionables_totales = puntos_nivel_anterior 
		
		# Limpiamos los objetos recogidos solo en este nivel para que puedas volver a por ellos
		coleccionables_recogidos.clear() 
		
		# Reseteamos el checkpoint para que no aparezca en mitad del mapa
		posicion_checkpoint = Vector2.ZERO 
		
		# Reiniciamos la escena
		get_tree().change_scene_to_file(ruta_escena)

func actualizar_hud_corazones():
	# Muestra u oculta los iconos de corazón en la interfaz según las vidas restantes
	if interfaz_corazones != null:
		var corazones = interfaz_corazones.get_children()
		for i in range(corazones.size()):
			corazones[i].visible = (i < vidas)
