extends CharacterBody2D

@export var velocidad : float = 170.0        # Velocidad de desplazamiento
@export var distancia_patrulla : float = 60.0 # Rango de movimiento

var direccion : int = 1
var posicion_inicial_x : float
var limite_derecha : float
var limite_izquierda : float

# Obtiene la gravedad del sistema
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D

var puede_hacer_daño : bool = true

func _ready():
	# Calcula los límites izquierdo y derecho al iniciar
	posicion_inicial_x = position.x
	limite_derecha = posicion_inicial_x + distancia_patrulla
	limite_izquierda = posicion_inicial_x - distancia_patrulla

func _physics_process(delta):
	# Aplica gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0 

	# Movimiento horizontal y cambio de dirección al tocar límites
	velocity.x = direccion * velocidad
	
	if position.x >= limite_derecha:
		direccion = -1
		sprite.flip_h = true # Gira el dibujo a la izquierda
	elif position.x <= limite_izquierda:
		direccion = 1
		sprite.flip_h = false # Gira el dibujo a la derecha
	
	move_and_slide()

	# Gestión de colisiones
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto = colision.get_collider()
		
		if objeto.name == "Santa":
			# Detecta si Santa lo pisa (colisión desde arriba)
			if colision.get_normal().dot(Vector2.UP) > 0.5:
				if objeto.has_method("rebotar"):
					objeto.rebotar() # Hace que Santa salte
				add_collision_exception_with(objeto) # Evita choques extra
				queue_free() # Elimina al enemigo
				break
			else:
				# Daño lateral: Santa pierde vida
				if GameManager.has_method("perder_vida"):
					GameManager.perder_vida()
