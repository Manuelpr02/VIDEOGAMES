extends Area2D

# Permite seleccionar el archivo .tscn del siguiente nivel desde el Inspector
@export_file("*.tscn") var siguiente_escena : String

func _on_body_entered(body):
	# Validamos que el objeto que entra al área sea el jugador
	if body.name == "Santa":
		# 1. Desactivamos las físicas de Santa para que no se mueva durante la animación
		body.set_physics_process(false)
		
		# 2. Obtenemos referencias a los nodos de la interfaz de transición
		var transicion = get_node("../Transicion") 
		var filtro = transicion.get_node("Filtro")
		var animador = transicion.get_node("AnimationPlayer")
		
		# 3. Sincronización con el Shader:
		# Calculamos la posición de Santa relativa a la pantalla (valores de 0 a 1)
		var pos_pantalla = body.get_global_transform_with_canvas().origin / get_viewport().get_visible_rect().size
		# Enviamos esa posición al parámetro del shader para que el círculo se cierre sobre él
		filtro.material.set_shader_parameter("posicion_santa", pos_pantalla)
		
		# 4. Ejecutamos la animación de cierre (típicamente un fundido o iris)
		animador.play("cerrar")
		
		# 5. Esperamos a que la animación termine antes de proseguir
		await animador.animation_finished
		
		# 6. Limpieza del estado global en el GameManager
		GameManager.posicion_checkpoint = Vector2.ZERO # El nuevo nivel empieza desde el inicio
		GameManager.vidas = 5 # Restauramos las vidas para el siguiente reto
		
		# 7. Cambio de escena definitivo
		if siguiente_escena != "":
			_cambiar_de_nivel()

# Función encargada de realizar el salto a la nueva escena
func _cambiar_de_nivel():
	get_tree().change_scene_to_file(siguiente_escena)
