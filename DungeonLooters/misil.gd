extends Area2D

@export var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Si sale de la pantalla, se borra
	queue_free()

func _on_body_entered(body: Node) -> void:
	# Si toca a un enemigo (asegúrate de que los enemigos estén en el grupo "enemies")
	if body.is_in_group("enemies"):
		print("¡Enemigo destruido!")
		body.queue_free() # Borra al enemigo
		queue_free()      # Borra el misil (para que no siga atravesando enemigos)
	
	# 2. ¿Es una pared (TileMap)?
	elif body is TileMapLayer or body.name == "TileMapLayer":
		print("El misil chocó contra un muro")
		queue_free() # El misil explota al chocar con la pared
