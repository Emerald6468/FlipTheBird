extends Control

@onready var image_1 = preload("res://Assets/icon.svg")
@onready var image_2 = preload("res://Assets/pickupable pebble_pinkrocktexture.jpg")
@onready var image_3 = preload("res://Assets/texturedrock3_bluerocktexture.jpg")
var cutscene_1
var cutscene_1_length
var page = 0
@onready var texture_rect: TextureRect = $CanvasLayer/ColorRect/TextureRect

var just_hovered = false
@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene_1 = [
		image_1,
		image_2,
		image_3
	]
	cutscene_1_length = len(cutscene_1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if page >= cutscene_1_length: 
		Global.have_played_c1 = true
		get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
	else: texture_rect.texture = cutscene_1[page]
	if just_hovered:
		just_hovered = false
		hover.stop()
		hover.play()

func _on_next_button_pressed() -> void:
	clicked.play()
	page+=1


func _on_next_button_mouse_entered() -> void:
	pass # Replace with function body.
