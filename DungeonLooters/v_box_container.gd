extends VBoxContainer

@onready var coin_label = $CoinLabel
@onready var message_label = $MessageLabel
@onready var treasure_label = $TreasureLabel
# Referencias para los corazones
@onready var corazones_container = $CorazonesContainer
@onready var corazon_template = $CorazonesContainer/CorazonTemplate

func _ready():
	# Conexiones existentes
	GameEvents.coin_collected.connect(_on_coin_collected)
	GameEvents.all_coins_collected.connect(_on_all_coins)
	GameEvents.treasure_collected.connect(_on_treasure_collected)
	
	# Conexiones de vida
	GameEvents.health_changed.connect(_on_health_changed)
	GameEvents.player_died.connect(_on_player_died)
	
	# Ocultamos el template para que no se vea doble al empezar
	corazon_template.visible = false
	
	# Estado inicial
	_reset_ui_visuals()

func _on_coin_collected(actual):
	coin_label.text = "Monedas: " + str(actual)

func _on_all_coins():
	message_label.text = "¡EL TESORO HA APARECIDO!"
	message_label.modulate = Color.GOLD

func _on_treasure_collected(totales):
	treasure_label.text = "Tesoros: " + str(totales)
	
	# --- CONTROL DE MENSAJE UNIFICADO ---
	# Comprobamos si estamos en el Nivel 3 y si este es el tercer tesoro recogido en total
	if get_tree().current_scene.name == "Nivel3" and totales == 3:
		message_label.text = "¡EL TESORO SECRETO HA APARECIDO!"
		message_label.modulate = Color.GOLDENROD # Un tono dorado diferente o el que prefieras
	else:
		# Mensaje normal para el resto de niveles o situaciones
		message_label.text = "¡TESORO RECOGIDO!"
		message_label.modulate = Color.WHITE # O el color por defecto de tus textos

# --- LÓGICA DE CORAZONES ---

func _on_health_changed(actual):
	actualizar_corazones(actual)

func actualizar_corazones(vidas_restantes):
	# 1. Limpiamos los corazones actuales (excepto el molde/template)
	for corazon in corazones_container.get_children():
		if corazon != corazon_template:
			corazon.queue_free()
	
	# 2. Creamos tantos corazones como vida nos quede
	for i in range(vidas_restantes):
		var nuevo_corazon = corazon_template.duplicate()
		nuevo_corazon.visible = true
		corazones_container.add_child(nuevo_corazon)

func _on_player_died():
	await get_tree().create_timer(2.0).timeout
	_reset_ui_visuals()

func _reset_ui_visuals():
	# Leemos 'total_collected_coins' para mantener la coherencia global de tu sistema de señales
	coin_label.text = "Monedas: " + str(GameEvents.total_collected_coins)
	treasure_label.text = "Tesoros: " + str(GameEvents.total_treasures)
	message_label.text = ""
	actualizar_corazones(GameEvents.current_health)
