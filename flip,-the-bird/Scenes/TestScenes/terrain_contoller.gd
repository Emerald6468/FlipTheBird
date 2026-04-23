extends Node3D
class_name TerrainController
#Loads different kinds of terrain and stitches them together
#Terrain passed by the player is unloaded
#(Think of this like placing different plates of sushi on a conveyor belt)

#All different terrain types/shapes are catalogued here
var level_segments: Array = []
#terrain that is currently visible in the view port 
var level_segments_visible: Array[MeshInstance3D] = []
#speed which terrain moves towards the player (currently very small for testing)
@export var terrain_velocity: float = 0.5
#Number of segments to keep rendered in viewport
@export var total_segments_visible: float = 5
#Path to directory holding level segments
#@export_dir var get_level_segments = "res://LevelSegments/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#These lines are for testing, will be reworked later
	#_load_terrain_scenes(get_level_segments)
	#_init_segment(total_segments_visible)
	pass # Replace with function body.
	
func _append_to_far_edge(get_level_segments: MeshInstance3D, segment: MeshInstance3D) -> void:
	#segment.position.z = segment.position.z - segment.mesh.size.y/2 - segment.mesh.size.y/2
	pass

func _init_segments(number_of_segments: int) -> void:
	for segment_index in number_of_segments:
		var segment = level_segments.pick_random().instantiate()
		if segment_index == 0:
			segment.z.position = $Player.z - randi_range(380,420)
		else:
			#_append_to_far_edge(level_segments_visible[segment_index - 1], segment)
			add_child(segment)
			level_segments_visible.append(segment)
	pass

func _progress_segments(delta: float) -> void:
	for segment in level_segments_visible:
		segment.position.z += 0.5 * delta
	if level_segments_visible[0].position.z >= $Player.z + 100:
		var last_segment = level_segments_visible[-1]
		var farthest_segment = level_segments_visible.pop_front()
		
		var segment = level_segments.pick_random().instantiate()
		#_append_to_far_edge(last_segment, segment)
		add_child(segment)
		level_segments_visible.append(segment)
	pass
