extends Control

@export var tilemap: TileMapLayer
@export var player: CharacterBody2D

var visited_cells: Dictionary = {} 
var revealed_treasures: Dictionary = {} # Guarda los tesoros descubiertos con tus ojos
var grid_size: int = 3
@export var map_offset: Vector2 = Vector2(50, 50)

func _ready() -> void:
	add_to_group("minimap")

# El mapa le envía una lista de coordenadas cuando el jugador camina
func reveal_cells(cells: Array[Vector2i]) -> void:
	for c in cells:
		visited_cells[c] = true
		
		# Cuando pisas una celda, revisamos si hay algún tesoro visible EN ESA CELDA
		for tesoro in get_tree().get_nodes_in_group("tesoros"):
			if is_instance_valid(tesoro) and tesoro.visible:
				var t_cell = tilemap.local_to_map(tilemap.to_local(tesoro.global_position))
				if t_cell == c:
					revealed_treasures[t_cell] = true # Guardamos que el jugador lo ha vuelto a ver
					
	queue_redraw()

func is_cell_revealed(cell: Vector2i) -> bool:
	return visited_cells.has(cell)

func _process(_delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	
	# --- NUEVA LÓGICA: LIMPIAR TESOROS RECOGIDOS ---
	# Creamos una lista con las celdas que están guardadas como tesoros en el minimapa
	var celdas_a_revisar = revealed_treasures.keys()
	
	for t_cell in celdas_a_revisar:
		var todavia_existe = false
		
		# Buscamos si queda algún tesoro vivo en el juego que coincida con esa celda
		for tesoro in get_tree().get_nodes_in_group("tesoros"):
			if is_instance_valid(tesoro):
				var actual_cell = tilemap.local_to_map(tilemap.to_local(tesoro.global_position))
				if actual_cell == t_cell:
					todavia_existe = true
					break
		
		# Si ya no hay ningún tesoro en esa posición, lo borramos del minimapa
		if not todavia_existe:
			revealed_treasures.erase(t_cell)
	
	queue_redraw()

func reset_minimap() -> void:
	visited_cells.clear()
	revealed_treasures.clear() 
	queue_redraw()

func _draw() -> void:
	if not tilemap: return

	draw_set_transform(map_offset, 0, Vector2(1, 1))

	# 1. Dibujar el rastro del mapa (Azul)
	for cell in visited_cells:
		draw_rect(Rect2(cell.x * grid_size, cell.y * grid_size, grid_size, grid_size), Color(0.1, 0.4, 1.0, 0.5))

	# 2. Dibujar Items (Cian)
	for item in get_tree().get_nodes_in_group("items"):
		var i_cell = tilemap.local_to_map(tilemap.to_local(item.global_position))
		if visited_cells.has(i_cell):
			draw_rect(Rect2(i_cell.x * grid_size, i_cell.y * grid_size, grid_size, grid_size), Color.CYAN)

	# 3. Dibujar Enemigos (Rojo)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		var e_cell = tilemap.local_to_map(tilemap.to_local(enemy.global_position))
		if visited_cells.has(e_cell):
			draw_rect(Rect2(e_cell.x * grid_size, e_cell.y * grid_size, grid_size, grid_size), Color.RED)

	# 4. Dibujar Escaleras Reales (Magenta / Morado)
	var escalera = get_node_or_null("/root/" + get_tree().current_scene.name + "/ESCALERA_REAL")
	if not escalera:
		escalera = get_parent().get_node_or_null("ESCALERA_REAL")
		
	if escalera:
		var esc_cell = tilemap.local_to_map(tilemap.to_local(escalera.global_position))
		if visited_cells.has(esc_cell):
			draw_rect(Rect2(esc_cell.x * grid_size, esc_cell.y * grid_size, grid_size, grid_size), Color.MAGENTA)

	# 5. TODOS LOS TESOROS (Amarillo)
	for t_cell in revealed_treasures:
		draw_rect(Rect2(t_cell.x * grid_size, t_cell.y * grid_size, grid_size, grid_size), Color.YELLOW)

	# 6. Dibujar Jugador (Verde)
	if player:
		var p_cell = tilemap.local_to_map(tilemap.to_local(player.global_position))
		draw_rect(Rect2(p_cell.x * grid_size, p_cell.y * grid_size, grid_size, grid_size), Color.GREEN)
