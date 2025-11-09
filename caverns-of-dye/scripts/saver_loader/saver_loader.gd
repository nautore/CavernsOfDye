class_name SaverLoader
extends Node

@onready var player:Player = %Player as Player

func save_game():
	var saved_game := SavedGame.new()
	
	# Store player position and # of insects captured
	saved_game.player_position = player.global_position
	saved_game.insects_captured = player.insects_captured
	saved_game.player_health = player.health
	saved_game.gold = player.gold
	saved_game.nets = player.nets
	
	# write the savegame to disk
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	var saved_game:SavedGame = load("user://savegame.tres") as SavedGame
	
	
	# clear the stage
	# MIGHT NEED SOMETHING LIKE THIS LATER
	#get_tree().call_group("game_events", "on_before_load_game")
	
	# restore player position
	player.global_position = saved_game.player_position
	# restore # of captured insects
	player.insects_captured = saved_game.insects_captured
	# restore player health
	player.health = saved_game.player_health
	# restore player gold
	player.gold = saved_game.gold
	# restore player nets
	player.nets = saved_game.nets

func _on_save_button_pressed() -> void:
	save_game()

func _on_load_button_pressed() -> void:
	load_game()
