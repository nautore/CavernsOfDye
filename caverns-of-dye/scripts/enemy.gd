extends CharacterBody2D

var SPEED = 40
var health = 100
@onready var player = %Player

func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized() * SPEED
	move_and_slide()

func get_hit():
	health -= 50
	if(health <= 0):
		queue_free()
