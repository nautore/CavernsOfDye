class_name Player
extends CharacterBody2D

@export var speed = 200
var can_shoot = true
var is_lethal = true
var is_invincible = false

@export var insects_captured:int = 0
@export var gold:int = 0
@export var nets:int = 2
@onready var health:int = 100


@onready var animation = $AnimatedSprite2D
@onready var shoot_source = $ShootSource
@onready var saver_loader = %SaverLoader
#@onready var merchant = %Merchant

@onready var arrow_scene = preload("res://scenes/arrow.tscn")
@onready var net_scene = preload("res://scenes/net.tscn")


func _ready():	
	#var insects = get_tree().get_nodes_in_group("insects")
	#for insect in insects:
		#insect.connect("captured", Callable(self, "on_insect_capture"))
	connect_insects()
func _physics_process(delta: float) -> void:
	velocity.x = Input.get_axis("left", "right") * speed
	velocity.y = Input.get_axis("up", "down") * speed
	
	
	if(!can_shoot):
		#velocity.x = 0
		#velocity.y = 0
		speed = 50
	else:
		speed = 200
		if(velocity.x != 0 || velocity.y != 0):
			animation.play("run2")
		else:
			animation.play("idle2")

	if(Input.is_action_just_pressed("left")):
		animation.flip_h = true
	if(Input.is_action_just_pressed("right")):
		animation.flip_h = false
	
	if(Input.is_action_just_pressed("quit")):
		#saver_loader.save_game()
		#get_tree().quit()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
	if(Input.is_action_just_pressed("interact")):
		var merchant = get_tree().get_first_node_in_group("merchant")
		merchant.interact()
		
	#if(Input.is_action_just_pressed("ui_accept")):
		#saver_loader.load_game()
		
	var shoot_dir = get_global_mouse_position()
	# DONT NEED after setting window to exclusive fullscreen
	#shoot_dir.y += 45
	shoot_source.look_at(shoot_dir)
	
	if(Input.is_action_just_pressed("shoot") && can_shoot):
		can_shoot = false
		is_lethal = true
		animation.play("shoot2")
	if(Input.is_action_just_pressed("throw") && can_shoot):
		if(nets >= 1):
			can_shoot = false
			is_lethal = false
			animation.play("shoot2")

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var object = collision.get_collider()
		if(object.is_in_group("enemies")):
			get_hit()


func _on_animated_sprite_2d_animation_finished() -> void:
	if(!can_shoot):
		can_shoot = true
		# check whether to shoot arrow or throw net
		if(is_lethal):
			var arrow = arrow_scene.instantiate()
			arrow.global_position = shoot_source.global_position
			arrow.global_rotation = shoot_source.global_rotation
			get_parent().add_child(arrow)
		else:
			var net = net_scene.instantiate()
			net.global_position = shoot_source.global_position
			net.global_rotation = shoot_source.global_rotation
			$/root/Game.add_child(net)
			
func on_insect_capture():
	insects_captured += 1
	nets -= 1
	print_debug(insects_captured)

func get_hit():
	if(!is_invincible):
		is_invincible = true
		$InvincibilityTimer.start()
		health -= 25
		if(health <= 0):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			
func connect_insects():
	var insects = get_tree().get_nodes_in_group("insects")
	for insect in insects:
		insect.connect("captured", Callable(self, "on_insect_capture"))
		
func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
