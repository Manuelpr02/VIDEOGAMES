extends Node

signal coin_collected(total_actual)
signal treasure_collected(tesoros_totales)
signal all_coins_collected
signal health_changed(vidas_restantes)
signal player_died 

@export_group("Estadísticas Globales")
var total_collected_coins : int = 0  # Monedas totales de toda la partida
var total_treasures : int = 0        # Tesoros totales de toda la partida

@export_group("Estadísticas de Nivel")
var total_coins_in_level : int = 0   # Cuántas hay en el mapa actual
var current_coins : int = 0    
var total_treasures_collected: int = 0      # Cuántas lleva en el nivel actual

var max_health : int = 3
var current_health : int = 3

func lose_health():
	current_health -= 1
	health_changed.emit(current_health)
	
	if current_health <= 0:
		player_died.emit()
		current_health = max_health 

# Se llama al empezar cada nivel
func reset_counts(total: int):
	total_coins_in_level = total
	current_coins = 0 
	current_health = max_health 
	health_changed.emit(current_health) 
	print("Nuevo nivel: Salud reseteada y contador de nivel a 0.")

# --- NUEVA FUNCIÓN: SE LLAMA DESDE LA UI AL MORIR ---
func reset_coins_on_death() -> void:
	# 1. Restamos las monedas que el jugador recolectó en este intento fallido del contador global
	total_collected_coins -= current_coins
	
	# 2. Reseteamos el contador de monedas del nivel actual a 0
	current_coins = 0
	
	# 3. Emitimos la señal con el total global corregido para que la UI se actualice inmediatamente
	coin_collected.emit(total_collected_coins)
	print("Muerte: Monedas del intento actual descartadas. Total global ajustado.")

func collect_coin():
	current_coins += 1
	total_collected_coins += 1 
	
	coin_collected.emit(total_collected_coins) 
	
	if current_coins >= total_coins_in_level:
		all_coins_collected.emit()

func collect_treasure():
	total_treasures += 1 
	treasure_collected.emit(total_treasures)
	print("¡Tesoro conseguido! Total acumulado: ", total_treasures)

# Función extra por si quieres reiniciar todo el juego desde un menú
func full_reset():
	total_collected_coins = 0
	total_treasures = 0
	current_health = max_health
