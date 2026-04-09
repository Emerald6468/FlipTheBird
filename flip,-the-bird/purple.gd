extends Node
#Anything can be a scene. Make sure this script/parent node is inside another scene!
#Scripts are nested below a node/mesh/etc.
#Scripts can be assigned names on creation
#Comments are followed by a "#" symbol
#GD Script is case-sensitive
#When the Debugger displays an error, click on it to view it in the code!


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Lines belong to this function by being indented
	#Semi-colons are not required
	#Child nodes are referenced with $ symbol in front
	#Child nodes can be dragged into code for referencing!
	$Label.text = "Hello, world."
	$Label.modulate = Color.INDIGO
	
