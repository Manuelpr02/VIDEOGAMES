extends CharacterBody2D

@export var velocidad_max = 280.0
@export var aceleracion = 10.0
@export var friccion = 10.0
@export var velocidad_giro = 4.0

@export var ajuste_sprite_grados = 90.0
var contador_vueltas = 0

func sumar_vuelta():
	contador_vueltas += 1
	print("¡Has completado una vuelta! Total: ", contador_vueltas)
	
func _physics_process(delta):
	var direccion_giro = Input.get_axis("ui_left", "ui_right")
	var acelerar = Input.get_axis("ui_up", "ui_down")
	
	if velocity.length() > 10:
		rotation += direccion_giro * velocidad_giro * delta
	
	if acelerar != 0:
		var frente = Vector2.RIGHT.rotated(rotation - deg_to_rad(ajuste_sprite_grados))
		velocity = velocity.lerp(frente * (-acelerar * velocidad_max), aceleracion * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friccion * delta)
	
	move_and_slide()
