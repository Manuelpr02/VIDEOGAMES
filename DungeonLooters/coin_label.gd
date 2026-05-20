extends Label

func _ready() -> void:
	GameEvents.coin_collected.connect(_on_coin_collected)
	# Al principio no sabemos cuántas hay, así que ponemos un texto genérico
	text = "Busca las monedas..."

func _on_coin_collected(quedan: int):
	text = "Faltan " + str(quedan) + " monedas"
