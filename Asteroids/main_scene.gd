extends Node2D

var puntos_jugador: int = 0
var puntos_ia: int = 0

# Referencias a los textos (ajusta la ruta si es necesario)
@onready var label_jugador = $CanvasLayer/LabelJugador
@onready var label_ia = $CanvasLayer/LabelIA

func _ready():
	actualizar_interfaz()

func sumar_punto_jugador():
	puntos_jugador += 1
	actualizar_interfaz()

func sumar_punto_ia():
	puntos_ia += 1
	actualizar_interfaz()

func actualizar_interfaz():
	label_jugador.text = "Puntos jugador: " + str(puntos_jugador)
	label_ia.text = "Puntos IA: " + str(puntos_ia)
