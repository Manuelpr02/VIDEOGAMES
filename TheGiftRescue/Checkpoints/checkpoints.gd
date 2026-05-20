extends Area2D

func _ready():
	# Conecta la señal de entrada de un cuerpo a la función correspondiente
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Solo se activa si el objeto que entra tiene el nombre "Santa"
	if body.name == "Santa":
		# Guarda en el GameManager el punto de reaparición con un desfase (offset)
		# Se suma 100 en X y se restan 110 en Y para que no aparezca dentro del suelo
		GameManager.posicion_checkpoint = global_position + Vector2(100, -110)
		
		# Cambia el color del objeto a verde para indicar que se activó
		modulate = Color.GREEN
