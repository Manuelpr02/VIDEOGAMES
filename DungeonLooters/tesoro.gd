extends Area2D

# Esta variable la modificará el mapa al vuelo para avisarle
var es_tesoro_secreto: bool = false

func _ready():
	# --- AÑADE ESTA LÍNEA AQUÍ ---
	add_to_group("tesoros")
	
	# Conectamos las señales primero para que estén listas
	GameEvents.all_coins_collected.connect(_on_reveal)
	body_entered.connect(_on_body_entered)

	# --- CONTROL DE INICIO ---
	if es_tesoro_secreto:
		visible = true
		monitoring = true
		var col = get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = false
	else:
		visible = false
		set_deferred("monitoring", false)

	# --- CONTROL DE INICIO ---
	if es_tesoro_secreto:
		# Si es el secreto, tiene que aparecer activo e inmediatamente visible
		visible = true
		monitoring = true
		# Nos aseguramos de que su CollisionShape2D esté despierto
		var col = get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = false
	else:
		# Si es el tesoro normal del nivel, se esconde como siempre
		visible = false
		set_deferred("monitoring", false) 

func _on_reveal():
	# Esto solo lo usará el tesoro normal cuando consigas las monedas
	show() 
	set_deferred("monitoring", true) 
	print("¡El tesoro ha aparecido en una sala aleatoria! ¡Ve a buscarlo!")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameEvents.collect_treasure() 
		GameEvents.total_treasures_collected += 1 
		queue_free()
