extends Area2D

var direction: Vector2
const SPEED = 10

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("enemies")):
		body.get_hit()
		queue_free()
		
