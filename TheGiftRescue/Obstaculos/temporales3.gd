extends AnimatableBody2D

func _ready():
	# La plataforma empieza oculta e intangible al cargar el nivel
	desaparecer()

func aparecer():
	show() # Muestra el gráfico
	# Activa la colisión de forma segura para el motor de físicas
	$CollisionShape2D.set_deferred("disabled", false)

func desaparecer():
	hide() # Oculta el gráfico
	# Desactiva la colisión para que el jugador la atraviese
	$CollisionShape2D.set_deferred("disabled", true)

# Se ejecuta cuando el Timer individual de esta plataforma termina
func _on_timer_timeout():
	aparecer()
	
	var padre = get_parent()
	var mi_nombre = name 
	
	# LÓGICA DE SECUENCIA:
	# Si se activa la 2, manda a encender el cronómetro de la 4
	if mi_nombre == "Temporales2":
		padre.get_node("Temporales4/Timer").start()
	
	# Si es la última de la serie (Temporales4)
	elif mi_nombre == "Temporales4":
		# Espera un tiempo antes de limpiar el camino
		await get_tree().create_timer(1.5).timeout
		reiniciar_ciclo()

func reiniciar_ciclo():
	var p = get_parent()
	var nombres = ["Temporales2", "Temporales4"]
	
	# Oculta todas las plataformas de la lista
	for n in nombres:
		var b = p.get_node_or_null(n)
		if b and b.has_method("desaparecer"):
			b.desaparecer()
	
	# Pequeña pausa de seguridad y reinicia la PRIMERA plataforma de la cadena
	await get_tree().create_timer(0.5).timeout
	var primera = p.get_node_or_null("Temporales")
	if primera:
		primera.get_node("Timer").start()
