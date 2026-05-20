extends Area2D

var speed: float = 500.0
var disparado_por_ia: bool = false # Nueva variable

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	# Si tu 'sprite' de bala mira hacia ARRIBA por defecto:
	position += Vector2.UP.rotated(rotation) * speed * delta
	
	# Si tu 'sprite' de bala mira hacia la DERECHA por defecto:
	# position += Vector2.RIGHT.rotated(rotation) * speed * delta
func _on_body_entered(body: Node2D) -> void:
	# CASO A: La bala es de la IA y golpea al JUGADOR
	if disparado_por_ia and body.is_in_group("jugador"):
		var main = get_tree().root.find_child("MainScene", true, false)
		if main: 
			main.sumar_punto_ia()
		queue_free() 
	
	# CASO B: La bala es tuya y golpea a un ENEMIGO
	elif not disparado_por_ia and body.is_in_group("enemigos"):
		var main = get_tree().root.find_child("MainScene", true, false)
		if main: 
			main.sumar_punto_jugador()
		
		# body.queue_free()  <-- BORRA O COMENTA ESTA LÍNEA para que la IA no desaparezca
		
		queue_free() # La bala sí desaparece para que no atraviese al enemigo y dé mil puntos
