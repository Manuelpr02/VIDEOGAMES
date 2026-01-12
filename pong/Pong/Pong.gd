extends Node2D

const CENTER = Vector2(640, 360) # Define el centro de la pantalla
var player_score = 0             # Puntos del jugador
var computer_score = 0           # Puntos de la IA

# Se ejecuta al iniciar el juego
func _ready() -> void:
	player_score = 0
	computer_score = 0
	$PlayerScore.text = "0"      # Pone el texto del marcador en 0
	$ComputerScore.text = "0"
	reset()                      # Coloca todo en su sitio inicial

# Se activa cuando la pelota entra en la portería izquierda (punto para la IA)
func _on_goal_left_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		computer_score += 1
		$ComputerScore.text = str(computer_score) # Actualiza el texto de puntos IA
		reset() # Reinicia la posición

# Se activa cuando la pelota entra en la portería derecha (punto para ti)
func _on_goal_right_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		player_score += 1
		$PlayerScore.text = str(player_score) # Actualiza el texto de tus puntos
		reset() # Reinicia la posición

# Función para devolver la pelota y las palas al centro
func reset() -> void:
	$Ball.position = CENTER               # Mueve la pelota al centro
	$Ball.call("set_ball_velocity")       # Lanza la pelota de nuevo
	$Player.position.y = CENTER.y         # Centra tu pala verticalmente
	$Computer.position.y = CENTER.y       # Centra la pala de la IA verticalmente
