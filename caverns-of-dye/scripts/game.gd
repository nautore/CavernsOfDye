class_name Game
extends Node2D

@export var world_root : Node2D
@onready var player = $/root/Game/WorldRoot/Player as Player
@onready var net_upgrade_button: Button = $CanvasLayer/SaveLoadPanel/VBoxContainer/NetUpgradeButton
@onready var heal_button: Button = $CanvasLayer/SaveLoadPanel/VBoxContainer/HealButton
@onready var light_button: Button = $CanvasLayer/SaveLoadPanel/VBoxContainer/LightUpgradeButton

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
	# also reset health and nets
	if(new_scene == "safe_zone"):
		net_upgrade_button.disabled = false
		heal_button.disabled = false
		light_button.disabled = false
		for key in Global.enteredLevels:
			Global.enteredLevels.set(key, false)
		#player.health = player.max_health
		player.nets = player.max_nets
		player.gold = player.gold - 20
		Global.days_survived += 1
		if(player.in_debt):
			player.gold = player.gold + (player.insects_captured * 10)
			GlobalAudio.play_sound("trade")
			player.insects_captured = 0
			if(player.gold < 0):
				player.kill()
		if(player.gold < 0):
			player.in_debt = true
		else:
			player.in_debt = false
		return
	else:
		net_upgrade_button.disabled = true
		heal_button.disabled = true
		light_button.disabled = true
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


func _on_net_upgrade_button_pressed() -> void:
	if(player.gold >= 15):
		player.gold = player.gold - 15
		player.max_nets = player.max_nets + 1
		player.nets = player.max_nets
		GlobalAudio.play_sound("trade")
	else:
		GlobalAudio.play_sound("denied")

func _on_heal_button_pressed() -> void:
	if(player.gold >= 20 && player.health < player.max_health):
		player.gold = player.gold - 20
		player.health = player.max_health
		GlobalAudio.play_sound("trade")
	else:
		GlobalAudio.play_sound("denied")


func _on_light_upgrade_button_pressed() -> void:
	if(player.gold >= 30):
		player.gold = player.gold - 30
		$/root/Game/CanvasLayer/UI.duration_seconds += 10
		GlobalAudio.play_sound("trade")
	else:
		GlobalAudio.play_sound("denied")	
