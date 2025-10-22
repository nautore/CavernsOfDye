extends CharacterBody2D

const SPEED = 200
var canShoot = true
var isLethal = true
@onready var animation = $AnimatedSprite2D
@onready var shoot_source = $ShootSource
@onready var arrow_scene = preload("res://scenes/arrow.tscn")
@onready var net_scene = preload("res://scenes/net.tscn")

func _physics_process(delta: float) -> void:
	
	
	velocity.x = Input.get_axis("left", "right") * SPEED
	velocity.y = Input.get_axis("up", "down") * SPEED
	
	if(!canShoot):
		velocity.x = 0
		velocity.y = 0
	else:
		if(velocity.x != 0 || velocity.y != 0):
			animation.play("run2")
		else:
			animation.play("idle2")
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
		
	var shoot_dir = get_global_mouse_position()
	shoot_dir.y += 45
	shoot_source.look_at(shoot_dir)
	
	if(Input.is_action_just_pressed("shoot") && canShoot):
		canShoot = false
		isLethal = true
		animation.play("shoot2")
	if(Input.is_action_just_pressed("throw") && canShoot):
		canShoot = false
		isLethal = false
		animation.play("shoot2")

	move_and_slide()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if(!canShoot):
		canShoot = true
		# check whether to shoot arrow or throw net
		if(isLethal):
			var arrow = arrow_scene.instantiate()
			arrow.global_position = shoot_source.global_position
			arrow.global_rotation = shoot_source.global_rotation
			get_parent().add_child(arrow)
		else:
			var net = net_scene.instantiate()
			net.global_position = shoot_source.global_position
			net.global_rotation = shoot_source.global_rotation
			$/root/GameWorld.add_child(net)
