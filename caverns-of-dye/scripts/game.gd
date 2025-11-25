class_name Game
extends Node2D

@export var world_root : Node2D
@onready var player = $/root/Game/WorldRoot/Player
var current_scene

func _ready() -> void:
	Global.game = self
	#current_scene = load("res://scenes/levels/safe_zone.tscn").instantiate()
	#world_root.add_child(current_scene)
	
	#change_scene(Global.levels.get("safe_zone"))
	change_scene("safe_zone")
	
func change_scene(new_scene: String):
	if(current_scene != null):
		current_scene.queue_free()
	#var new = load(new_scene).instantiate()
	var scene_path = Global.levels.get(new_scene)
	var new = load(scene_path).instantiate()
	world_root.add_child(new)
	current_scene = new
	
	player.connect_insects()
	
	# reset enteredLevels when entering safe_zone
	if(new_scene == "safe_zone"):
		for key in Global.enteredLevels:
			Global.enteredLevels.set(key, false)
		return
	
	# cleared already entered levels of enemies and insects
	if(Global.enteredLevels.get(new_scene) == true):
		var enemies = get_tree().get_nodes_in_group("enemies")
		var insects = get_tree().get_nodes_in_group("insects")
		for enemy in enemies:
			enemy.queue_free()
		for insect in insects:
			insect.queue_free()
	else:
		Global.enteredLevels.set(new_scene, true)
