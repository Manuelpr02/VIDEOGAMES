extends Node

# Estas variables guardarán los datos entre escenas
var puntos_finales : int = 0
var tiempo_final : String = ""

func guardar_partida(p, t):
	puntos_finales = p
	tiempo_final = t
