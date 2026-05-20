extends PathFollow2D

@export var velocidad = 200.0
@export var suavizado = 0.2
@export var desfase_grados = 90.0 

# Variable para almacenar las vueltas de este coche específico
var contador_vueltas = 0

@onready var cuerpo_fisico = $CharacterBody2D

func _ready():
	rotates = false

func _process(delta):
	var posicion_inicial = global_position
	
	progress += velocidad * delta
	
	var direccion = (global_position - posicion_inicial).normalized()
	
	if cuerpo_fisico:
		# IMPORTANTE: Para que el Area2D detecte al coche, 
		# el CharacterBody2D debe moverse con move_and_slide
		cuerpo_fisico.velocity = direccion * velocidad
		cuerpo_fisico.move_and_slide()
		
		global_position = cuerpo_fisico.global_position

	var rotacion_camino = get_parent().curve.sample_baked_with_rotation(progress).get_rotation()
	var rotacion_objetivo = rotacion_camino + deg_to_rad(desfase_grados)
	
	rotation = lerp_angle(rotation, rotacion_objetivo, suavizado)

# Esta función será llamada por la "Meta" (Area2D) cuando el coche la cruce
func sumar_vuelta():
	contador_vueltas += 1
	print("El coche verde ha completado la vuelta: ", contador_vueltas)
