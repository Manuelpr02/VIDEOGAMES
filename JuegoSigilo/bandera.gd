extends Area2D

@onready var anim = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		print("Cambiando de nivel...")
		body.ganar_juego()
