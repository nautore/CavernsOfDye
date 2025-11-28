extends Node

var levels : Dictionary = { "safe_zone": "res://scenes/levels/safe_zone.tscn",
							"level_0": "res://scenes/levels/level_0.tscn",
							"level_1": "res://scenes/levels/level_1.tscn",
							"level_2": "res://scenes/levels/level_2.tscn",
							"level_3": "res://scenes/levels/level_3.tscn",
							"level_4": "res://scenes/levels/level_4.tscn",
							"level_5": "res://scenes/levels/level_5.tscn",
							"level_6": "res://scenes/levels/level_6.tscn",
							"level_7": "res://scenes/levels/level_7.tscn",
							"level_8": "res://scenes/levels/level_8.tscn",
							"level_9": "res://scenes/levels/level_9.tscn",
							"level_10": "res://scenes/levels/level_10.tscn"
							}
var game : Game
var in_cave = false

var enteredLevels : Dictionary = {  "level_0": false,
									"level_1": false,
									"level_2": false,
									"level_3": false,
									"level_4": false,
									"level_5": false,
									"level_6": false,
									"level_7": false,
									"level_8": false,
									"level_9": false,
									"level_10": false
								}
