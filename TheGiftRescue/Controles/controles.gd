extends Label

func _ready():
	# Espera un temporizador de 4 segundos antes de actuar
	await get_tree().create_timer(4.0).timeout
	
	# Crea un Tween para animar la transparencia
	var tween = create_tween()
	
	# Cambia el canal alfa (transparencia) a 0 en el transcurso de 1 segundo
	tween.tween_property(self, "modulate:a", 0, 1.0)
	
	# Cuando la animación termina, elimina el Label por completo de la memoria
	tween.finished.connect(queue_free)
