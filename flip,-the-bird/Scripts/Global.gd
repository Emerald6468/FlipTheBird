extends Node

var forward_velocity = 0.0
# Increases in intervals of 50 based on total flips + multiplier
var score = 0

#game over logic
var game_over = false
var is_fragile = false

#ENDLESS RUNNER
var velocity = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func reset_state():
	pass
