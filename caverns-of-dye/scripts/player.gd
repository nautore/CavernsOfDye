extends CharacterBody2D

const SPEED = 200
var isShooting = false
@onready var animation = $AnimatedSprite2D
@onready var arrow_scene = preload("res://scenes/arrow.tscn")

func _physics_process(delta: float) -> void:
	#look_at(get_global_mouse_position())
	
	velocity.x = Input.get_axis("left", "right") * SPEED
	velocity.y = Input.get_axis("up", "down") * SPEED
	
	if(isShooting):
		velocity.x = 0
		velocity.y = 0
	else:
		if(velocity.x != 0 || velocity.y != 0):
			animation.play("run")
		else:
			animation.play("idle")
	#if(velocity.x != 0 || velocity.y != 0):
		#if(animation.animation != "shoot"):
			#animation.play("run")
	#else:
		#animation.play("idle")

	if(Input.is_action_just_pressed("left")):
		animation.flip_h = true
	if(Input.is_action_just_pressed("right")):
		animation.flip_h = false
	
	if(Input.is_action_just_pressed("quit")):
		get_tree().quit()
		
	if(Input.is_action_just_pressed("shoot")):
		isShooting = true
		animation.play("shoot")
		

	move_and_slide()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if(isShooting):
		isShooting = false
		var arrow = arrow_scene.instantiate()
		arrow.global_position = global_position
		arrow.direction = (get_global_mouse_position() - global_position).normalized()
		$/root/GameWorld.add_child(arrow)
