extends Area2D

@export var next_level:String
@export var locked := false
var enemies

func _ready() -> void:
	enemies = get_tree().get_nodes_in_group("enemies")
	if(enemies.size() != 0):
		locked = true
func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		enemies = get_tree().get_nodes_in_group("enemies")
		if(enemies.size() == 0):
			locked = false
		#Global.game.change_scene(Global.levels.get(next_level))
		if(!locked):
			Global.game.call_deferred("change_scene", Global.levels.get(next_level))
