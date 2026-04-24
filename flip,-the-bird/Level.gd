extends Node3D

@onready var Segments: Node3D = $Segments

# Increases in intervals of 50 based on total flips + multiplier
var score = 0

#level generation
@onready var segment_spawner: Marker3D = $SegmentSpawner
var spawner_location 
@export var spawn_timer_length = 2.0
var just_spawned = false
var segment_list = []
var list_len = 0

#leveldeletion
@onready var deleter: Area3D = $Deleter


#level segments
@onready var segment1 = preload("res://Scenes/LevelSegments/segment1.tscn")
@onready var segment2 = preload("res://Scenes/LevelSegments/segment2.tscn")
@onready var segment3 = preload("res://Scenes/LevelSegments/segment3.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	spawner_location = segment_spawner.position
	Global.spawner_pos = spawner_location
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	segment_list = [
		segment2,
		segment3,
	]
	list_len = len(segment_list)
	

	
func spawn_segment():
	var ran_num = randi_range(0,list_len-1)
	var picked_segment = segment_list[ran_num]
	var new_segment = picked_segment.instantiate()
	Segments.add_child(new_segment)
	print("spawned")
	new_segment.global_position = spawner_location
	


func spawner_timer():
	if !just_spawned:
		just_spawned = true
		spawn_segment()
		await get_tree().create_timer(spawn_timer_length).timeout
		just_spawned = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawner_timer()
	Segments.position.z -= Global.velocity * delta
	if Global.game_over:
		print("GAME OVER")
		
	var area_list = deleter.get_overlapping_areas()
	if deleter.has_overlapping_areas():
		for area in area_list: 
			if area.is_in_group("Segment"):
				area.signal_emit()

func _input(event):
	if event.is_action_pressed("Restart"):
		Global.reset_var()
		get_tree().reload_current_scene()
