extends Control

var just_hovered = false
@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.visible = false

func turn_on():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CanvasLayer.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if just_hovered:
		just_hovered = false
		hover.stop()
		hover.play()


func _on_restart_pressed() -> void:
	clicked.play()
	Global.reset_var()
	get_tree().reload_current_scene()
