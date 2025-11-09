class_name Game
extends Node2D

@export var world_root : Node2D
@onready var player = $/root/Game/WorldRoot/Player
var current_scene

func _ready() -> void:
	Global.game = self
	#current_scene = load("res://scenes/levels/safe_zone.tscn").instantiate()
	#world_root.add_child(current_scene)
	change_scene(Global.levels.get("safe_zone"))
	
func change_scene(new_scene: String):
	if(current_scene != null):
		current_scene.queue_free()
	var new = load(new_scene).instantiate()
	world_root.add_child(new)
	current_scene = new
	player.connect_insects()
	
