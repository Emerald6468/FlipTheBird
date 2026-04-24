extends Node3D

@onready var detector: Area3D = $detector


func destroy_self():
	print("deleted")
	self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detector_delete_signal() -> void:
	destroy_self()
