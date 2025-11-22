extends Control

const GAME = preload("res://scenes/game.tscn")

func _ready():
	GlobalAudio.play_music("menu_music")
	$PanelContainer/GameGuideContainer.hide()
		
func _on_play_button_pressed() -> void:
	GlobalAudio.play_sound("click")
	GlobalAudio.play_music("background_music")
	get_tree().change_scene_to_packed(GAME)
func _on_game_guide_button_pressed() -> void:
	GlobalAudio.play_sound("click")
	$PanelContainer/MenuContainer.hide()
	$PanelContainer/GameGuideContainer.show()

func _on_quit_button_pressed() -> void:
	GlobalAudio.play_sound("click")
	get_tree().quit()
	
func _on_back_button_pressed() -> void:
	GlobalAudio.play_sound("click")
	$PanelContainer/GameGuideContainer.hide()
	$PanelContainer/MenuContainer.show()


func _on_back_button_mouse_entered() -> void:
	GlobalAudio.play_sound("hover")


func _on_play_button_mouse_entered() -> void:
	GlobalAudio.play_sound("hover")


func _on_game_guide_button_mouse_entered() -> void:
	GlobalAudio.play_sound("hover")


func _on_quit_button_mouse_entered() -> void:
	GlobalAudio.play_sound("hover")
