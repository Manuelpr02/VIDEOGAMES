extends Area2D

var next_scene_path: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CollisionShape2D.set_deferred("disabled", true)
		print("Cambiando hacia: ", next_scene_path)
		
		# Paramos el temporizador global al tocar la meta
		if has_node("/root/GlobalTimer"):
			GlobalTimer.is_active = false
			
		_cambiar_escena.call_deferred()

func _cambiar_escena():
	# --- CONTROL FIN DE JUEGO (NIVEL 3) ---
	if get_tree().current_scene.name == "Nivel3":
		# ¡RECUERDA!: Cambia esto por la ruta exacta de tu escena de victoria
		var fin_juego_scene = "res://pantalla_fin_juego.tscn" 
		
		print("¡Juego completado desde el Nivel 3! Cargando créditos/victoria...")
		var error_fin = get_tree().change_scene_to_file(fin_juego_scene)
		if error_fin != OK:
			print("Error: No se pudo cargar la pantalla de fin de juego en: ", fin_juego_scene)
		return # Cortamos aquí para que no ejecute el código de abajo

	# --- COMPORTAMIENTO NORMAL (NIVEL 1 Y 2) ---
	if next_scene_path == "" or next_scene_path == null:
		print("¡ERROR! La escalera no sabe a dónde ir. Revisa el Inspector del TileMapLayer.")
		return

	var error = get_tree().change_scene_to_file(next_scene_path)
	
	if error != OK:
		print("Error: No se pudo cargar la ruta: ", next_scene_path)
