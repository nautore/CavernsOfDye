extends Control

const GAME = preload("res://scenes/game.tscn")

func _ready():
	$PanelContainer/GameGuideContainer.hide()
		
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)
	
func _on_game_guide_button_pressed() -> void:
	$PanelContainer/MenuContainer.hide()
	$PanelContainer/GameGuideContainer.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_back_button_pressed() -> void:
	$PanelContainer/GameGuideContainer.hide()
	$PanelContainer/MenuContainer.show()
