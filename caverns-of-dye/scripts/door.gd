extends Area2D

@export var next_level:String


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		#Global.game.change_scene(Global.levels.get(next_level))
		Global.game.call_deferred("change_scene", Global.levels.get(next_level))
