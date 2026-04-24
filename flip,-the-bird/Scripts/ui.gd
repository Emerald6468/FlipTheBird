extends Control
@onready var score: Label = $CanvasLayer/Score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = str(Global.score)
	if Global.game_over:
		$CanvasLayer/GameOver.turn_on()
