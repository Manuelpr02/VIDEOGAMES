extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if body.has_method("collect_apple"):
			body.collect_apple() # Suma la manzana al contador del jugador 
			queue_free() # Elimina la manzana de la escena
