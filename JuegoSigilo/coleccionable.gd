extends Area2D

# Referencia al nodo de sonido
@onready var sonido = $AudioStreamPlayer2D

# Esta variable evitará que el código se ejecute más de una vez
var ya_recogido = false

func _on_body_entered(body: Node2D) -> void:
	# Si ya fue recogido o no es el jugador, no hacemos nada
	if ya_recogido or body.name != "Jugador":
		return
	
	# Marcamos como recogido inmediatamente
	ya_recogido = true
	
	# 1. Sumar el punto al jugador
	if body.has_method("añadir_punto"):
		body.añadir_punto()
	
	# 2. Reproducir el sonido
	if sonido:
		sonido.play()
	
	# 3. TRUCO: Ocultamos visualmente y desactivamos colisiones
	visible = false
	set_deferred("monitoring", false) # Usamos set_deferred para que sea seguro
	set_deferred("monitorable", false)
	
	# 4. Esperar a que termine el sonido y luego borrar el objeto
	if sonido:
		await sonido.finished
	
	queue_free()
