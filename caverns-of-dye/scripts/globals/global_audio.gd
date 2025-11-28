extends Node

var is_music_playing = false
var curr_music

# SFX
@onready var sfx_shoot = preload("res://assets/sfx/Bow Attack 1.ogg")
@onready var sfx_arrow_hit = preload("res://assets/sfx/Bow Impact Hit 1.ogg")
@onready var sfx_melee_hit = preload("res://assets/sfx/Sword Impact Hit 1.ogg")
@onready var sfx_insect_capture = preload("res://assets/sfx/Gate Close.ogg")
@onready var sfx_click = preload("res://assets/sfx/chop 3 - Copy.ogg")
@onready var sfx_hover = preload("res://assets/sfx/001_Hover_01.wav")
@onready var sfx_trade = preload("res://assets/sfx/079_Buy_sell_01.wav")
@onready var sfx_run1 = preload("res://assets/sfx/Stone Run 1.ogg")
@onready var sfx_run2 = preload("res://assets/sfx/Stone Run 2.ogg")
@onready var sfx_run3 = preload("res://assets/sfx/Stone Run 3.ogg")
@onready var sfx_run4 = preload("res://assets/sfx/Stone Run 4.ogg")
@onready var sfx_run5 = preload("res://assets/sfx/Stone Run 5.ogg")
@onready var sfx_denied = preload("res://assets/sfx/033_Denied_03.wav")
@onready var sfx_dash = preload("res://assets/sfx/15_human_dash_1.wav")

# Music
@onready var music_background = preload("res://assets/music/Sketchbook 2024-12-04.ogg")
@onready var music_cave = preload("res://assets/music/Sketchbook 2024-10-23.ogg")
@onready var music_menu = preload("res://assets/music/Sketchbook 2024-11-20.ogg")

func play_sound(sound_name: String):
	var instance = AudioStreamPlayer.new()
	match sound_name:
		# load appropriate sound to instance.stream
		"shoot":
			instance.stream = sfx_shoot
			instance.volume_db = 5
		"arrow_hit":
			instance.stream = sfx_arrow_hit
			instance.volume_db = 5
		"melee_hit":
			instance.stream = sfx_melee_hit
			instance.volume_db = 5
		"insect_capture":
			instance.stream = sfx_insect_capture
			instance.volume_db = 5
		"click":
			instance.stream = sfx_click
			instance.volume_db = 5
		"hover":
			instance.stream = sfx_hover
			instance.volume_db = 2
		"trade":
			instance.stream = sfx_trade
			instance.volume_db = 5
		"run1":
			instance.stream = sfx_run1
			instance.volume_db = -8
		"run2":
			instance.stream = sfx_run2
			instance.volume_db = -8
		"run3":
			instance.stream = sfx_run3
			instance.volume_db = -8
		"run4":
			instance.stream = sfx_run4
			instance.volume_db = -8
		"run5":
			instance.stream = sfx_run5
			instance.volume_db = -8
		"denied":
			instance.stream = sfx_denied
			instance.volume_db = -2
		"dash":
			instance.stream = sfx_dash
			instance.volume_db = -8
	instance.finished.connect(remove_sound.bind(instance))
	add_child(instance)
	instance.play()
	
func play_music(music_name: String):
	if(is_music_playing == true):
		remove_sound(curr_music)
	var instance = AudioStreamPlayer.new()
	match music_name:
		"background_music":
			instance.stream = music_background
			instance.volume_db = -8
		"cave_music":
			instance.stream = music_cave
			instance.volume_db = -8
		"menu_music":
			instance.stream = music_menu
			instance.volume_db = -8
	add_child(instance)
	instance.play()
	curr_music = instance
	is_music_playing = true
func remove_sound(instance: AudioStreamPlayer):
	instance.queue_free()
