class_name Player
extends CharacterBody2D

@export var speed = 230
@export var dash_speed = 500
@export var dash_duration = 0.4
@export var dash_cooldown = 1
var can_shoot = true
var is_lethal = true
var is_invincible = false
var dying = false
var can_play_step_sound = true
var is_dashing = false
var can_dash = true
var dash_timer = 0


@export var insects_captured:int = 0
@export var gold:int = 40
@export var nets:int = 3
@export var max_nets:int = 3
@export var health:int = 100
@export var max_health:int = 100
@export var in_debt:bool = false

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
	# if player is dying, dont allow any input
	if(dying):
		return
	
	# if player is moving, play footstep noises
	if((velocity.x != 0 || velocity.y != 0) && (can_shoot)):
		if(can_play_step_sound):
			var run_sound = randi_range(1, 5)
			var run_name = "run" + str(run_sound)
			GlobalAudio.play_sound(run_name)
			var step_timer = get_tree().create_timer(0.3)
			step_timer.connect("timeout", Callable(self, "_on_step_timer_timeout"))
			can_play_step_sound = false
	
	# old velocity code
	#velocity.x = Input.get_axis("left", "right") * speed
	#velocity.y = Input.get_axis("up", "down") * speed
	
	# new velocity code
	var direction = Input.get_vector("left", "right", "up", "down")
	if(!is_dashing):
		velocity = direction * speed
		if Input.is_action_just_pressed("dash") and can_dash:
			start_dash(direction)
	else:
		velocity = direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()
	
	if(!can_shoot):
		#velocity.x = 0
		#velocity.y = 0
		speed = 50
	else:
		speed = 200
		if(velocity.x != 0 || velocity.y != 0):
			if(!is_dashing):
				animation.play("run2")
		else:
			if(!is_dashing):
				animation.play("idle2")

	if(Input.is_action_just_pressed("left")):
		animation.flip_h = true
	if(Input.is_action_just_pressed("right")):
		animation.flip_h = false
	
	if(Input.is_action_just_pressed("quit")):
		#saver_loader.save_game()
		#get_tree().quit()
		GlobalAudio.play_music("menu_music")
		Global.days_survived = 0
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
		else:
			GlobalAudio.play_sound("denied")

	move_and_slide()
	
	# Enemy collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var object = collision.get_collider()
		if(object.is_in_group("enemies")):
			if(!object.dying):
				get_hit()


func _on_animated_sprite_2d_animation_finished() -> void:
	if(animation.animation == "death"):
		Global.in_cave = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return
	
	
	if(!can_shoot && animation.animation == "shoot2"):
		GlobalAudio.play_sound("shoot")
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
		GlobalAudio.play_sound("melee_hit")
		animation.self_modulate = Color(1, 0, 0, 1)
		if(health <= 0):
			dying = true
			animation.play("death")
			Global.high_score = max(Global.high_score, Global.days_survived)
			Global.days_survived = 0
			$/root/Game/CanvasLayer/UI.full_bar_reset()
			#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			
func connect_insects():
	var insects = get_tree().get_nodes_in_group("insects")
	for insect in insects:
		insect.connect("captured", Callable(self, "on_insect_capture"))

func kill():
	health = 1
	max_nets = 3
	max_health = 100
	get_hit()
func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
	animation.self_modulate = Color(1, 1, 1, 1)

func _on_step_timer_timeout() -> void:
	can_play_step_sound = true
	
func start_dash(direction):
	is_dashing = true
	can_dash = false
	dash_timer = dash_duration
	can_shoot = false
	
	#animation.play("dash")
	GlobalAudio.play_sound("dash")
	
	# If no direction is inputted, dash forward
	if direction == Vector2.ZERO:
		velocity = Vector2(1, 0) * dash_speed  # Dash to the right by default
	else:
		velocity = direction * dash_speed
		
	var dash_cooldown_timer = get_tree().create_timer(dash_cooldown)
	dash_cooldown_timer.connect("timeout", Callable(self, "_on_dash_cooldown_timer_timeout"))
	
func end_dash():
	is_dashing = false
	can_shoot = true
	
func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	
