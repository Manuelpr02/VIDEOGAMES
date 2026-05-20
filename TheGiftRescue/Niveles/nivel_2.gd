extends Node2D

func _ready():
	# Lógica inicial del nivel
	GameManager.iniciar_nuevo_nivel(name)
