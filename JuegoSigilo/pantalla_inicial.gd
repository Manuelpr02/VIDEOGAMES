extends Control

func _on_iniciar_pressed():
	# Cambia "res://main_scene.tscn" por la ruta real de tu escena principal
	get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_finalizar_pressed() -> void:
	get_tree().quit()
