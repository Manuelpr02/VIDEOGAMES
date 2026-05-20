extends CharacterBody2D

@export var speed: float = 150.0

func _process(delta: float) -> void:
	var horizontal: float = Input.get_axis("ui_left", "ui_right")
	var vertical: float = Input.get_axis("ui_up", "ui_down")
	var direction := Vector2(horizontal, vertical).normalized()
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
