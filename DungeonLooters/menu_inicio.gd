extends Control

# Arrastra aquí tu escena del Nivel 1 desde el sistema de archivos
@export_file("*.tscn") var nivel_1_path: String = "res://nivel_1.tscn"

func _ready() -> void:
	# Conectamos las señales de los botones
	$VBoxContainer/BotonJugar.pressed.connect(_on_jugar_pressed)
	$VBoxContainer/BotonSalir.pressed.connect(_on_salir_pressed)
	
	# Aseguramos que el ratón sea visible (por si venimos de morir o algo)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_jugar_pressed() -> void:
	if nivel_1_path != "":
		get_tree().change_scene_to_file(nivel_1_path)
	else:
		print("Error: No has asignado la escena del Nivel 1 en el Inspector")

func _on_salir_pressed() -> void:
	get_tree().quit()
