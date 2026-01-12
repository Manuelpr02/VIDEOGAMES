extends RigidBody2D

# Se ejecuta al crear el bloque
func _ready() -> void:
	# Añade el bloque a un grupo para poder contarlos después
	add_to_group("Brick")

# Se activa cuando tu pelota lo golpea
func hit():
	# Suma 1 punto al jugador en el GameManager
	GameManager.addPointsPlayer(1)
	# Llama a la función para borrar el bloque
	destroy_brick()

# Se activa cuando la pelota de la IA lo golpea
func hit_by_ai():
	# Suma 1 punto a la IA en el GameManager
	GameManager.addPointsAI(1)
	# Llama a la función para borrar el bloque
	destroy_brick()

# Función principal para eliminar el bloque y revisar el nivel
func destroy_brick():
	# Hace invisible el bloque y desactiva su colisión
	$Sprite2D.visible = false 
	$CollisionShape2D.set_deferred("disabled", true) 
	
	# Busca todos los bloques que quedan en la escena
	var bricks = get_tree().get_nodes_in_group("Brick")
	var count = 0
	for b in bricks:
		# Cuenta solo los que aún son visibles
		if b.get_node("Sprite2D").visible:
			count += 1
			
	# Si no quedan más bloques visibles, pasamos de nivel
	if count == 0:
		# Espera 1 segundo, sube el nivel y reinicia la escena
		await get_tree().create_timer(1).timeout 
		GameManager.level += 1 
		get_tree().reload_current_scene() 
	else:
		# Si aún quedan bloques, espera un poco y borra este bloque de la memoria
		await get_tree().create_timer(0.2).timeout
		queue_free()
