extends CharacterBody2D

const SPEED = 200

func _physics_process(delta: float) -> void:
	#look_at(get_global_mouse_position())
	
	velocity.x = Input.get_axis("left", "right") * SPEED
	velocity.y = Input.get_axis("up", "down") * SPEED
	
	if(velocity.x != 0 || velocity.y != 0):
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"

	if(Input.is_action_just_pressed("left")):
		$AnimatedSprite2D.flip_h = true
	if(Input.is_action_just_pressed("right")):
		$AnimatedSprite2D.flip_h = false
	
	if(Input.is_action_just_pressed("quit")):
		get_tree().quit()

	move_and_slide()
	
