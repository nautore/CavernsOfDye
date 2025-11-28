extends CharacterBody2D

signal captured

const SPEED = 150
var direction = 0
var dying = false

func _physics_process(delta: float) -> void:
	if(dying):
		return
	match direction:
		0: direction = Vector2.UP
		1: direction = Vector2.DOWN
		2: direction = Vector2.LEFT
		3: direction = Vector2.RIGHT
	#position += direction * SPEED * delta
	velocity = direction * SPEED
	if(direction == Vector2.LEFT):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	move_and_slide()
	
func get_captured():
	if(!dying):
		GlobalAudio.play_sound("insect_capture")
		emit_signal("captured")
		queue_free()
	
func get_hit():
	GlobalAudio.play_sound("arrow_hit")
	dying = true
	$AnimatedSprite2D.self_modulate = Color(1, 0, 0, 1)
	var hit_timer = get_tree().create_timer(0.25)
	hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
	$AnimatedSprite2D.play("death")

func _on_hit_timer_timeout() -> void:
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)

func _on_animated_sprite_2d_animation_finished() -> void:
	if($AnimatedSprite2D.animation == "death"):
		queue_free()

func _on_direction_timer_timeout() -> void:
	direction = randi() % 4
