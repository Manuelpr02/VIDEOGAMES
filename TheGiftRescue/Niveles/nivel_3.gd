extends Node2D

func _ready():
	# 1. Comunicación con el Singleton:
	# Envía el nombre del nodo raíz de esta escena al GameManager.
	# Esto permite al sistema saber en qué nivel estamos y gestionar 
	# los coleccionables para que no se dupliquen o se pierdan.
	GameManager.iniciar_nuevo_nivel(name)
	
	# 2. Control de Interfaz (UX):
	# Oculta el cursor del ratón para que no distraiga al jugador 
	# mientras controla a Santa, mejorando la inmersión.
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
