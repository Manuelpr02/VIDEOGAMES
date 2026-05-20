extends Area2D


func _ready() -> void:
	# Conectamos la señal de que algo entró en el área
	#body_entered.connect(_on_body_entered)
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.collect_coin() # Llamamos al global
		queue_free()
