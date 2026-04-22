extends Control
@onready var velocity: Label = $CanvasLayer/Velocity
@onready var score: Label = $CanvasLayer/Score
@onready var gameover: Label = $CanvasLayer/GAMEOVER
@onready var fragile: Label = $CanvasLayer/Fragile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.text = "Forward Velocity: " + str(Global.forward_velocity)
	score.text = "Score: " + str(Global.score)
	if Global.game_over:
		$CanvasLayer/GameOver.turn_on()
		gameover.text = "GAMEOVER"
	fragile.text = "Is Fragile: " + str(Global.is_fragile)
