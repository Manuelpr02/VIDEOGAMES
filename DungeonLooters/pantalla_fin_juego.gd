extends Control

@onready var tiempo_label = $VBoxContainer/TiempoLabel
@onready var monedas_label = $VBoxContainer/MonedasLabel
@onready var tesoros_label = $VBoxContainer/TesorosLabel

func _ready() -> void:
	print("--- CARGANDO PANTALLA FINAL ---")
	
	# 1. TIEMPO
	if has_node("/root/GlobalTimer"):
		var tiempo_total = GlobalTimer.time_elapsed
		tiempo_label.text = "Tiempo empleado: " + _formatear_tiempo(tiempo_total)
	else:
		tiempo_label.text = "Tiempo empleado: --:--"

	# 2. MONEDAS
	monedas_label.text = "Monedas conseguidas: " + str(GameEvents.total_collected_coins)

	# 3. TESOROS
	tesoros_label.text = "Tesoros encontrados: " + str(GameEvents.total_treasures)

func _formatear_tiempo(tiempo_en_segundos: float) -> String:
	var minutos : int = int(tiempo_en_segundos) / 60
	var segundos : int = int(tiempo_en_segundos) % 60
	return "%02d:%02d" % [minutos, segundos]
