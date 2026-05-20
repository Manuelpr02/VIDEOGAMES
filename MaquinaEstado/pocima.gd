extends Area3D

func _on_body_entered(body):
	if body.is_in_group("enemy") and body.has_method("heal_completely"):
		body.heal_completely()
		queue_free() # La pócima se consume [cite: 21]
