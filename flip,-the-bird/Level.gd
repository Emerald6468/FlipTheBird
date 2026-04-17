extends Node3D

@onready var all_ground: Node3D = $AllGround

# Increases in intervals of 50 based on total flips + multiplier
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Score is " + str(score))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	all_ground.position.z -= Global.velocity * delta
	if Global.game_over:
		print("GAME OVER")

func _input(event):
	if event.is_action_pressed("Escape"):
		get_tree().quit()
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
