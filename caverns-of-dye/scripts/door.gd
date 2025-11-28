extends Area2D

#@export var in_cave:bool = false
@export var next_level:String
@export var next_player_x:int
@export var next_player_y:int
@export var locked := false
var enemies
var can_transition = false

func _ready() -> void:
	# prevent multiple teleportations (needed here too)
	var transition_timer = get_tree().create_timer(0.5)
	transition_timer.connect("timeout", Callable(self, "_on_transition_timer_timeout"))
	
	enemies = get_tree().get_nodes_in_group("enemies")
	if(enemies.size() != 0):
		locked = true
func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player")):
		enemies = get_tree().get_nodes_in_group("enemies")
		if(enemies.size() == 0):
			locked = false
		#Global.game.change_scene(Global.levels.get(next_level))
		if(!locked && can_transition):
			#Global.game.call_deferred("change_scene", Global.levels.get(next_level))
			
			# prevent multiple teleportations
			can_transition = false
			var transition_timer = get_tree().create_timer(0.5)
			transition_timer.connect("timeout", Callable(self, "_on_transition_timer_timeout"))
			
			# move player and change level
			body.global_position.x = next_player_x
			body.global_position.y = next_player_y
			Global.game.call_deferred("change_scene", next_level)
			if(next_level == "safe_zone"):
				GlobalAudio.play_music("background_music")
				Global.in_cave = false
			else:
				# only start cave music when entering cave for the first time
				if(!Global.in_cave):
					GlobalAudio.play_music("cave_music")
					Global.in_cave = true
func _on_transition_timer_timeout() -> void:
	can_transition = true
