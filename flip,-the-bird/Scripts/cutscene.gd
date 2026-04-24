extends Control

#cutscene 1
@onready var image_1 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic1.png")
@onready var image_2 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic2.png")
@onready var image_3 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic3.png")
@onready var image_4 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic4.png")
@onready var image_5 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic5.png")
@onready var image_6= preload("res://Assets/Comic/OPENINGCOMIC/flip_comic6.png")
@onready var image_7 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic7.png")
@onready var image_8 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic8.png")
@onready var image_9 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic9.png")
@onready var image_10 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic10.png")
@onready var image_11 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic11.png")
@onready var image_12 = preload("res://Assets/Comic/OPENINGCOMIC/flip_comic12.png")

#cutscene 2
@onready var image_13 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC1.png")
@onready var image_14 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC2.png")
@onready var image_15 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC3.png")
@onready var image_16 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC4.png")
@onready var image_17 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC5.png")
@onready var image_18 = preload("res://Assets/Comic/ENDINGCOMIC/flip_comic-ENDCOMIC6.png")

var cutscene_1
var cutscene_1_length
var cutscene_2
var cutscene_2_length
var page = 0
@onready var texture_rect: TextureRect = $CanvasLayer/ColorRect/TextureRect

var just_hovered = false
@onready var hover: AudioStreamPlayer = $Hover
@onready var clicked: AudioStreamPlayer = $Clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page = 0
	cutscene_1 = [
		image_1,
		image_2,
		image_3,
		image_4,
		image_5,
		image_6,
		image_7,
		image_8,
		image_9,
		image_10,
		image_11,
		image_12
	]
	cutscene_1_length = len(cutscene_1)
	
	cutscene_2 = [
		image_13,
		image_14,
		image_15,
		image_16,
		image_17,
		image_18,
	]
	cutscene_2_length = len(cutscene_2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.high_score >= Global.goal:
		Global.have_played_c1 = true
		if page >= cutscene_2_length: 
			Global.have_played_c2 = true
			get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
		else: texture_rect.texture = cutscene_2[page]
	else:
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
