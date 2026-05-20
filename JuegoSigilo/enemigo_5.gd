extends CharacterBody2D

@export var speed: float = 80.0
@export var puntos_ruta: Node2D # Aquí arrastraremos el nodo que contiene los Markers

var objetivos = []
var indice_actual = 0
var objetivo_actual: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if puntos_ruta:
		# Guardamos las posiciones de todos los Markers
		for hijo in puntos_ruta.get_children():
			objetivos.append(hijo.global_position)
		
		if objetivos.size() > 0:
			objetivo_actual = objetivos[indice_actual]

func _physics_process(_delta):
	if objetivos.size() == 0:
		return

	# Calcular dirección hacia el punto actual
	var direction = global_position.direction_to(objetivo_actual)
	
	# Si estamos muy cerca del punto, pasamos al siguiente
	if global_position.distance_to(objetivo_actual) < 10:
		indice_actual = (indice_actual + 1) % objetivos.size()
		objetivo_actual = objetivos[indice_actual]
	
	velocity = direction * speed
	
	# Animaciones
	if velocity.length() > 0:
		animated_sprite.play("Jefe")
		animated_sprite.flip_h = (direction.x < 0)
	else:
		animated_sprite.stop()

	move_and_slide()


func _on_area_ataque_body_entered(body: Node2D) -> void:
	# Este mensaje DEBE salir si el área toca cualquier cosa
	print("AreaAtaque ha tocado algo: ", body.name)
	
	if body.name == "Jugador" or body.has_method("recibir_daño"):
		print("¡Es el jugador! Aplicando daño...")
		body.recibir_daño()
