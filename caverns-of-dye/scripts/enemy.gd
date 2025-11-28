extends CharacterBody2D

var SPEED = 150
var health = 100
var dying = false
@onready var player = $/root/Game/WorldRoot/Player

func _physics_process(delta: float) -> void:
	if(!dying):
		velocity = (player.global_position - global_position).normalized() * SPEED
		move_and_slide()
func get_hit():
	GlobalAudio.play_sound("arrow_hit")
	$AnimatedSprite2D.self_modulate = Color(1, 0, 0, 1)
	var hit_timer = get_tree().create_timer(0.25)
	hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
	
	health -= 50
	if(health <= 0):
		dying = true
		$AnimatedSprite2D.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if($AnimatedSprite2D.animation == "death"):
		queue_free()
		
func _on_hit_timer_timeout() -> void:
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 1)
