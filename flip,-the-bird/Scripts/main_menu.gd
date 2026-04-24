extends Control

@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked


var just_hovered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_var()
	if !Global.have_played_c1: get_tree().change_scene_to_file("res://Scenes/UI/Cutscene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if just_hovered:
		just_hovered = false
		hover.stop()
		hover.play()


func _on_start_button_pressed() -> void:
	clicked.play()
	get_tree().change_scene_to_file("res://Scenes/FinalScenes/DayLevel.tscn")


func _on_quit_button_pressed() -> void:
	clicked.play()
	get_tree().quit()


func _on_start_button_mouse_entered() -> void:
	just_hovered = true


func _on_quit_button_mouse_entered() -> void:
	just_hovered = true
