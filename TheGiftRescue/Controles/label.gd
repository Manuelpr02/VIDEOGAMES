extends Label

func _ready():
	# 1. Se suscribe a la señal del GameManager para detectar cambios en los puntos
	GameManager.actualizar_marcador.connect(_al_actualizar)
	
	# 2. Sincroniza el texto inmediatamente al iniciar la escena
	_al_actualizar()

func _al_actualizar():
	# Refresca el contenido del Label con el valor actual del Singleton
	text = "Puntos por regalos: " + str(GameManager.coleccionables_totales)
