extends Control

@onready var player = $/root/GameWorld/Player

func _process(delta: float) -> void:
	$PanelContainer/Label.text = str(player.insects_captured)
