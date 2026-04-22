extends Node3D
#All different terrain types/shapes are catalogued here
@onready var terrain_load = preload("res://Scenes/TestScenes/terrain_controller.tscn")
#How about preloading each hill individually?
@onready var hill_2 = preload("res://Scenes/Prefabs/LevelSegments/hill_2.tscn")
@onready var hill_3 = preload("res://LevelSegments/hill_3.tscn")
@onready var hill_4 = preload("res://LevelSegments/hill_4.tscn")
@onready var hill_5 = preload("res://LevelSegments/hill_5.tscn")
var terrain_scene
#Path to directory holding level segments
@export_dir var get_level_segments = "res://LevelSegments/"
#Preload hills so they can be created during gameplay

#Separate script for spawner and preloader?
#Spawner is child of the level scene
#@onready for all terrain
#Call function inside the spawner


#timer to prevent segments from spawning on top of each other
var gen_cooldown = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Randomize() for different level generation each play
	randomize()
	terrain_scene = [
	hill_2, 
	hill_3, 
	hill_4,
	hill_5
	]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Segment generator runs from player, should never be passed
	var speed = 1 # Change this to increase it to more units/second
	position = position.move_toward(Vector3(0,0,-30), delta * speed)
	
	#When timer reaches 0, generate a segment
	gen_cooldown += 1
	#print(str(terrain_scene))
	if gen_cooldown >= 240:
		#Select random .tscn file a convert it into a string (picked_segment)
		#IMPORTANT: Adjust randi_range for newly added segments (min:0, max: total - 1)
		var picked_segment = terrain_scene[round(randi_range(0,3))]
		#print(str(picked_segment))
		#Then, instantiate var picked_segment
		var new_segment = picked_segment.instantiate()
		add_child(new_segment)
		gen_cooldown = 0
	pass
	
	#Points
#var TotalPoints = 0
#var LevelPoints = 0
	
	#Save score between levels, and save max score between play sessions
#func score_and_save(content):
	#var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	#for i in LevelPoints:
		#TotalPoints += LevelPoints
		#file.store_string(TotalPoints)
	#if TotalPoints > 212026 && TotalPoints < 21250:
		#print("Danny saved my life")
	#pass
