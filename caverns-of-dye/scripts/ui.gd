extends Control

@export var duration_seconds: float = 60.0  # time to reach 0%
var elapsed: float = 0.0
var bar_active = false

@onready var player = %Player
@onready var bar = $ProgressBar

func _ready() -> void:
	bar.min_value = 0
	bar.max_value = 100
	bar.value = 100
	elapsed = 0.0

func _process(delta: float) -> void:
	$Panel/HBoxContainer/Label2.text = str(player.insects_captured)
	$Panel2/HBoxContainer/Label2.text = str(player.gold)
	$Panel3/HBoxContainer/Label2.text = str(player.health)
	$Panel4/HBoxContainer/Label2.text = str(player.nets)
	
	
	bar_active = Global.in_cave
	if(bar_active && bar.value > 0):
		elapsed += delta
		var t = clamp(elapsed / duration_seconds, 0.0, 1.0)
		bar.value = lerp(100.0, 0.0, t)
	if(bar_active && bar.value == 0):
		player.health = 0
		player.get_hit()
		Global.in_cave = false
		resetBar()
	if(!bar_active):
		resetBar()
func resetBar() -> void:
	bar.value = bar.max_value
	elapsed = 0.0
