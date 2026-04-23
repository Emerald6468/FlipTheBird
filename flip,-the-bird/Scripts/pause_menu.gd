extends Control

@onready var resume_button: Button = $CenterContainer/PanelContainer/VBoxContainer/ResumeButton
@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked

var just_hovered = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		_toggle_pause()

func _toggle_pause() -> void:
	var paused := not get_tree().paused
	get_tree().paused = paused
	visible = paused
	
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_resume_button_pressed() -> void:
	_toggle_pause()
	clicked.play()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	clicked.play()
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func _process(delta: float) -> void:
	if just_hovered:
		just_hovered = false
		hover.stop()
		hover.play()


func _on_resume_button_mouse_entered() -> void:
	just_hovered = true


func _on_menu_button_mouse_entered() -> void:
	just_hovered = true
