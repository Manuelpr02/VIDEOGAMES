extends Area2D

@export_file("*.tscn") var siguiente_escena : String

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Santa":
		body.set_physics_process(false)
		
		var transicion = get_node_or_null("../Transicion")
		if transicion:
			var animador = transicion.get_node("AnimationPlayer")
			animador.play("cerrar")
			await animador.animation_finished
		
		# --- LÍNEA CLAVE A MODIFICAR ---
		# Reseteamos la posición del checkpoint a cero antes de cambiar de nivel.
		# Esto obliga al Nivel 2 a poner a Santa en su posición de inicio original.
		GameManager.posicion_checkpoint = Vector2.ZERO 
		# -------------------------------

		if siguiente_escena != "":
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_file(siguiente_escena)
