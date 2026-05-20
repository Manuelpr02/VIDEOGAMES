extends HBoxContainer

func _ready():
	# 1. Registra este contenedor en el GameManager para que sea accesible globalmente
	GameManager.interfaz_corazones = self
	
	# 2. Sincroniza visualmente los corazones con el número de vidas actual del jugador
	GameManager.actualizar_hud_corazones()
