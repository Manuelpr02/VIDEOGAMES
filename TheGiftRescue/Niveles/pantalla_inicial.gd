extends Control

func _ready():
	# 1. Recupera el control del puntero
	# Si venimos de un nivel donde el ratón estaba oculto, esto lo hace visible
	# para que el usuario pueda interactuar con los botones.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Se activa al hacer clic en el botón de Inicio/Jugar
func _on_inicio_pressed() -> void:
	# 2. RESET DE PERSISTENCIA (GameManager)
	# Como el GameManager es un Autoload (Singleton), sus variables no se borran solas.
	# Es obligatorio resetearlas manualmente para no empezar con puntos o vidas de antes.
	GameManager.coleccionables_totales = 0
	GameManager.vidas = 5
	GameManager.puntos_nivel_anterior = 0
	GameManager.coleccionables_recogidos.clear()
	GameManager.posicion_checkpoint = Vector2.ZERO
	GameManager.nivel_actual_nombre = ""
	
	# 3. TRANSICIÓN DE ESCENA
	# Se intenta cargar el primer nivel. El resultado se guarda en 'error'.
	var error = get_tree().change_scene_to_file("res://Niveles/nivel_1.tscn")
	
	# 4. DEPURACIÓN
	# Si la ruta está mal escrita o el archivo no existe, nos avisa en la consola.
	if error != OK:
		print("Error: No se encuentra la escena del Nivel 1. Revisa la ruta.")

# Se activa al hacer clic en el botón de Salir
func _on_cerrar_pressed() -> void:
	# Cierra la ventana del juego y finaliza el proceso.
	get_tree().quit()
