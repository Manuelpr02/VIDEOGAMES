extends Node2D

# Carga la escena del ladrillo para poder crear copias
@onready var brickObject = preload("res://scenes/brick.tscn")

var spacing = 32      # Espacio entre cada ladrillo
var start_y = 200     # Altura a la que empieza la primera fila

func _ready() -> void:
	# Crea el nivel nada más empezar
	setupLevel()

func setupLevel():
	# Calcula el ancho de la pantalla para saber cuántos ladrillos caben
	var screen_width = get_viewport_rect().size.x
	var columns = int(screen_width / spacing) 
	
	var start_x = 16    # Margen izquierdo inicial
	
	# Calcula cuántas filas habrá según el nivel (máximo 12)
	var rows = 6 + GameManager.level
	if rows > 12: rows = 12
	
	# Obtiene la lista de colores neón
	var colors = getColors()
				
	# Bucle doble: crea filas (r) y columnas (c)
	for r in rows:
		for c in columns:
			# Crea una instancia nueva del ladrillo
			var newBrick = brickObject.instantiate()
			add_child(newBrick)
			
			# Ajusta el tamaño del ladrillo a la mitad
			newBrick.get_node("Sprite2D").scale = Vector2(0.5, 0.5)
			
			# Calcula la posición exacta de cada ladrillo en la cuadrícula
			newBrick.position = Vector2(start_x + (spacing * c), start_y + (spacing * r))
			
			# Cambia el color del ladrillo según la fila en la que esté
			var sprite = newBrick.get_node('Sprite2D')
			if r < 3:
				sprite.modulate = colors[0] # Filas 0-2 (Cian)
			elif r < 6:
				sprite.modulate = colors[1] # Filas 3-5 (Violeta)
			elif r < 9:
				sprite.modulate = colors[2] # Filas 6-8 (Rojo)
			else:
				sprite.modulate = colors[3] # Resto de filas (Blanco)

# Define los colores neón para que combinen con el fondo y las palas
func getColors():
	return [
		Color(0.0, 1.0, 1.0, 1.0),   # Cian
		Color(0.6, 0.2, 1.0, 1.0),   # Violeta
		Color(1.0, 0.2, 0.2, 1.0),   # Rojo
		Color(0.9, 0.9, 1.0, 1.0)    # Blanco brillante
	]
