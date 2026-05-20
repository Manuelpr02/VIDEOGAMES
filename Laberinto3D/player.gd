extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.1
@export var jump_force: float = 12.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90.0), \
														   deg_to_rad(90.0))
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _physics_process(delta: float) -> void:
	var dir: Vector3 = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		dir -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		dir += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		dir -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		dir += transform.basis.x
	dir = dir.normalized()

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	if is_on_floor():
		if Input.is_key_pressed(KEY_SPACE):
			velocity.y = jump_force
		else:
			velocity.y = 0.0
	else:
		velocity.y -= gravity * delta

	move_and_slide()
