extends Node3D

#List of segments to be loaded into level with random variation
var level_segments = [
	preload("res://LevelSegments/hill_2.tscn"),
	preload("res://LevelSegments/hill_3.tscn"),
	preload("res://LevelSegments/hill_4.tscn"),
	preload("res://LevelSegments/hill_5.tscn")
]

#Potential solution for loading packeged scenes into level
#@export var level_segments : Array[PackedScene] = []

#Increases in intervals of 50 based on t"res://hill_2.tscn"otal flips + multiplier
@onready var all_ground: Node3D = $AllGround

# Increases in intervals of 50 based on total flips + multiplier
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Call randomize for level segments
	randomize()
	#spawn_level_segments(0,0,-2000)
	#spawn_level_segments(0,0,-2160)
	print("Score is " + str(score))
	pass # Replace with function body.

#func spawn_level_segments(x,y,z):
	#var inst = level_segments[randi() % len(level_segments)].instance()
	#inst.position = Vector3(x,y,z)
	#$ZanderTestScene.add_child(inst)
	#pass
#
#func manage_level_segmets(x,y,z):
	#for area in $ZanderTestScene.get_children():
		##area.position.z -= 0 * delta
		#if area.position.x < -1240:
			#spawn_level_segments(area.position.z + 2048,0,0)
			#area.queue_free()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	all_ground.position.z -= Global.velocity * delta
	if Global.game_over:
		print("GAME OVER")

func _input(event):
	if event.is_action_pressed("Escape"):
		#Referenced for saving score on level quit
		var player_script = $player.gd() 
		player_script.save_and_quit()
		get_tree().quit()
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()
