extends CharacterBody2D

@export var velocidad : float = 40.0
@export var distancia_patrulla : float = 50.0 

var direccion : int = 1
var posicion_inicial_x : float
var limite_derecha : float
var limite_izquierda : float

# Obtiene la gravedad configurada en el proyecto
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D

func _ready():
	# Define los límites de movimiento según la posición actual
	posicion_inicial_x = position.x
	limite_derecha = posicion_inicial_x + distancia_patrulla
	limite_izquierda = posicion_inicial_x - distancia_patrulla

func _physics_process(delta):
	if not is_inside_tree(): return # Seguridad: evita errores si el nodo no está en escena

	# Aplica gravedad si está en el aire
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0 

	# Establece velocidad horizontal
	velocity.x = direccion * velocidad
	
	# Control de patrulla y cambio de dirección (giro de sprite)
	if position.x >= limite_derecha:
		direccion = -1
		sprite.flip_h = true 
	elif position.x <= limite_izquierda:
		direccion = 1
		sprite.flip_h = false
	
	move_and_slide() # Ejecuta el movimiento físico

	# --- GESTIÓN DE COLISIONES ---
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto = colision.get_collider()
		
		if objeto.name == "Santa":
			# Si el golpe viene desde arriba (normal positiva en Y), el enemigo muere
			if colision.get_normal().y > 0.5:
				if objeto.has_method("rebotar"):
					objeto.rebotar() # Santa salta al pisarlo
				queue_free() # El enemigo desaparece
				break
			else:
				# Si el golpe es lateral, Santa recibe daño
				if GameManager.has_method("perder_vida"):
					set_physics_process(false) # Detiene al enemigo tras el golpe
					GameManager.perder_vida()
