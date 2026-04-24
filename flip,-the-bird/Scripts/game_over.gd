extends Control

var just_hovered = false
@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked
@onready var hs: Label = $CanvasLayer/ColorRect/HighScore/HS
@onready var s: Label = $CanvasLayer/ColorRect/Score/S

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.visible = false

func turn_on():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Global.high_score < Global.score: Global.high_score = Global.score
	hs.text = str(Global.high_score)
	s.text = str(Global.score)
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
