extends Area2D

var direction: Vector2
const SPEED = 1000
	

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("enemies")):
		queue_free()
	if(body.is_in_group("insects")):
		body.get_captured()
		queue_free()
