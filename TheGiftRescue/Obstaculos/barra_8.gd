extends AnimatableBody2D

@export var distancia: float = 270.0 # Píxeles a mover a la izquierda
@export var tiempo: float = 3.0      # Duración del trayecto

var posicion_original: Vector2      # Memoria de la posición inicial
var activada: bool = false          # Estado actual de la plataforma
var tween: Tween                    # Referencia al controlador de animación

func _ready():
	# Al cargar, guarda la posición de inicio
	posicion_original = position

func _physics_process(_delta):
	# Detecta si hay algo justo encima (simulando un sensor)
	var colision_arriba = move_and_collide(Vector2(0, -1), true)
	var santa_encima = false
	
	# Verifica si el objeto detectado se llama "Santa"
	if colision_arriba:
		if colision_arriba.get_collider().name == "Santa":
			santa_encima = true

	# Si Santa sube y no estaba activa, se mueve
	if santa_encima and not activada:
		ir_a_la_izquierda()
	# Si Santa baja o se quita, regresa
	elif not santa_encima and activada:
		volver_al_inicio()

func ir_a_la_izquierda():
	activada = true
	if tween: tween.kill() # Detiene el movimiento actual para evitar conflictos
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Mueve hacia la izquierda (resta en X)
	tween.tween_property(self, "position:x", posicion_original.x - distancia, tiempo)

func volver_al_inicio():
	activada = false
	if tween: tween.kill() # Detiene el movimiento actual
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Regresa a la coordenada X original
	tween.tween_property(self, "position:x", posicion_original.x, tiempo)
