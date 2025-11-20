extends StaticBody2D

@onready var player = $/root/Game/WorldRoot/Player
@onready var can_interact = false

func interact():
	if(can_interact):
		if(player.insects_captured > 0):
			GlobalAudio.play_sound("trade")
			var earned_gold = player.insects_captured * 10
			player.gold = player.gold + earned_gold
			player.insects_captured = 0
		else:
			GlobalAudio.play_sound("denied")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		can_interact = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.is_in_group("player")):
		can_interact = false
