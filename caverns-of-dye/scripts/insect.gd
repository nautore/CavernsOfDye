extends CharacterBody2D

signal captured

const SPEED = 150
var direction = 0

func _physics_process(delta: float) -> void:
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
	emit_signal("captured")
	queue_free()
	
func get_hit():
	queue_free()

func _on_timer_timeout() -> void:
	direction = randi() % 4
