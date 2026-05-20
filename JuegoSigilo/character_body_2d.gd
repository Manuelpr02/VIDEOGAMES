extends CharacterBody2D

@export var movement_speed: float = 50.0
var salud_actual: int = 3
var invulnerable: bool = false
var posicion_inicial: Vector2 # Para volver al principio
# --- VARIABLES DEL CRONÓMETRO ---
var tiempo_transcurrido: float = 0.0
@onready var label_cronometro = get_tree().root.find_child("CronometroLabel", true, false)
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Buscamos los 3 cuadros de colores en el HUD
@onready var lista_vidas = [
	get_tree().root.find_child("Vida1", true, false),
	get_tree().root.find_child("Vida2", true, false),
	get_tree().root.find_child("Vida3", true, false)
]
# --- SISTEMA DE PUNTOS ---
var puntos: int = 0

# Buscamos el Label en el HUD
@onready var label_puntos = get_tree().root.find_child("Contador", true, false)

func añadir_punto():
	puntos += 1
	actualizar_texto_puntos()

func actualizar_texto_puntos():
	if label_puntos:
		label_puntos.text = "Banderas: " + str(puntos)
func _ready():
	posicion_inicial = global_position # Guardamos el punto de inicio
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	actualizar_interfaz()

func recibir_daño():
	if invulnerable:
		return
	
	print("¡Recibiendo daño!") # Si sale esto en consola, el problema son los cuadros de color
	salud_actual -= 1
	actualizar_interfaz()
	
	# Teletransporte al inicio
	global_position = posicion_inicial
	navigation_agent.target_position = posicion_inicial
	velocity = Vector2.ZERO # Detenerlo en seco
	
	if salud_actual <= 0:
		morir()
	else:
		activar_invulnerabilidad()

func actualizar_interfaz():
	# Oculta los cuadros de derecha a izquierda
	if salud_actual == 2 and lista_vidas[2]: lista_vidas[2].hide()
	elif salud_actual == 1 and lista_vidas[1]: lista_vidas[1].hide()
	elif salud_actual == 0 and lista_vidas[0]: lista_vidas[0].hide()

func activar_invulnerabilidad():
	invulnerable = true
	modulate = Color(1, 0, 0, 0.7) 
	await get_tree().create_timer(1.0).timeout
	modulate = Color(1, 1, 1, 1)
	invulnerable = false

func morir():
	print("Jugador eliminado")
	# Esto evita el error rojo. Pide el reinicio para el siguiente frame.
	get_tree().call_deferred("reload_current_scene")

# --- MOVIMIENTO MANTENIDO ---
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		navigation_agent.target_position = get_global_mouse_position()

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		animated_sprite.stop()
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * movement_speed
	
	animated_sprite.play("caminar")
	animated_sprite.flip_h = (direction.x < 0)
	
	move_and_slide()
func _process(delta):
	# Sumamos el tiempo que pasa en cada fotograma
	tiempo_transcurrido += delta
	actualizar_interfaz_cronometro()

func actualizar_interfaz_cronometro():
	if label_cronometro:
		# Calculamos minutos y segundos
		var minutos = int(tiempo_transcurrido) / 60
		var segundos = int(tiempo_transcurrido) % 60
		
		# Formateamos el texto para que siempre tenga dos dígitos (ej: 01:05)
		label_cronometro.text = "Tiempo: %02d:%02d" % [minutos, segundos]

func ganar_juego():
	# 1. Guardamos los datos en el Autoload
	# label_cronometro.text es el String "00:00" que ya tienes
	Global.guardar_partida(puntos, label_cronometro.text)
	
	# 2. Cambiamos de escena
	get_tree().call_deferred("change_scene_to_file", "res://PantallaVictoria.tscn")
