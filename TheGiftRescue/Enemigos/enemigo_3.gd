extends CharacterBody2D

@export var velocidad : float = 45.0
@export var distancia_patrulla : float = 30.0 

var direccion : int = 1
var posicion_inicial_x : float
var limite_derecha : float
var limite_izquierda : float

# Obtiene la gravedad del proyecto
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D

var puede_hacer_daño : bool = true

func _ready():
	# Define los límites de movimiento según la posición de inicio
	posicion_inicial_x = position.x
	limite_derecha = posicion_inicial_x + distancia_patrulla
	limite_izquierda = posicion_inicial_x - distancia_patrulla

func _physics_process(delta):
	# Aplica gravedad si no está tocando el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0 

	# Control de dirección y volteo de sprite al llegar a los límites
	velocity.x = direccion * velocidad
	
	if position.x >= limite_derecha:
		direccion = -1
		sprite.flip_h = true 
	elif position.x <= limite_izquierda:
		direccion = 1
		sprite.flip_h = false
	
	move_and_slide() # Aplica el movimiento físico

	# Revisa cada colisión ocurrida en este frame
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var objeto = colision.get_collider()
		
		if objeto.name == "Santa":
			# Detecta si Santa pisa la cabeza (vector normal hacia arriba)
			if colision.get_normal().dot(Vector2.UP) > 0.5:
				if objeto.has_method("rebotar"):
					objeto.rebotar()
				add_collision_exception_with(objeto) # Evita choques extra al morir
				queue_free() # Elimina al enemigo
				break
			else:
				# Si el contacto es lateral, quita vida a través del GameManager
				if GameManager.has_method("perder_vida"):
					GameManager.perder_vida()
