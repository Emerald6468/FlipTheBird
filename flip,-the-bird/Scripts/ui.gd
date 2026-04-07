extends Control
@onready var velocity: Label = $CanvasLayer/Velocity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.text = "Forward Velocity: " + str(Global.forward_velocity)
