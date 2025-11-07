extends Control

@onready var player = %Player

func _process(delta: float) -> void:
	$Panel/HBoxContainer/Label2.text = str(player.insects_captured)
	$Panel2/HBoxContainer/Label2.text = str(player.gold)
