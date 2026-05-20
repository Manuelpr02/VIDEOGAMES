extends AnimatableBody2D

func _ready():
	# Al iniciar el juego, la plataforma se oculta y se vuelve intangible
	desaparecer()

func aparecer():
	show()
	# Habilita la colisión de forma segura al final del frame de física
	$CollisionShape2D.set_deferred("disabled", false)

func desaparecer():
	hide()
	# Deshabilita la colisión para que el jugador caiga a través de ella
	$CollisionShape2D.set_deferred("disabled", true)

# Se activa cuando el Timer de esta plataforma llega a cero
func _on_timer_timeout():
	aparecer()
	
	var padre = get_parent()
	var mi_nombre = name 
	
	# LÓGICA DE CADENA: Cada plataforma activa el cronómetro de la siguiente
	if mi_nombre == "Temporales":
		padre.get_node("Temporales2/Timer").start()
	elif mi_nombre == "Temporales2":
		padre.get_node("Temporales3/Timer").start()
	elif mi_nombre == "Temporales3":
		padre.get_node("Temporales4/Timer").start()
	elif mi_nombre == "Temporales4":
		# Si es la última plataforma, esperamos 3 segundos antes de limpiar el camino
		await get_tree().create_timer(3).timeout
		reiniciar_ciclo()

func reiniciar_ciclo():
	var p = get_parent()
	# Lista con todos los nombres de los nodos que forman la secuencia
	var nombres = ["Temporales", "Temporales2", "Temporales3", "Temporales4"]
	
	# Recorre la lista y llama a la función desaparecer en cada objeto encontrado
	for n in nombres:
		var b = p.get_node_or_null(n)
		if b and b.has_method("desaparecer"):
			b.desaparecer()
	
	# Pausa de medio segundo y vuelve a iniciar la primera plataforma (Temporales)
	await get_tree().create_timer(0.5).timeout
	var primera = p.get_node_or_null("Temporales")
	if primera:
		primera.get_node("Timer").start()
