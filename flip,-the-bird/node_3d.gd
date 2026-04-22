extends Node
#Anything can be a scene. Make sure this script/parent node is inside another scene!
#Scripts are nested below a node/mesh/etc.
#Scripts can be assigned names on creation
#Comments are followed by a "#" symbol
#GD Script is case-sensitive
#When the Debugger displays an error, click on it to view it in the code!

#Variables are written with "var"
#Variables can be made static (consistent data type) with a colon
var variable1 := 52
#By being static, variable1 cannot be anything other than an integer
#Godot Math: c = (a+b), a += b, a -= b, a *= b, a /= b

#To set values through the inspector, prefix the variable with @export
@export var variable2 = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Lines belong to this function by being indented
	#Semi-colons are not required
	#Child nodes are referenced with $ symbol in front
	#Child nodes can be dragged into code for referencing!
	#Attach scripts referencing child nodes to parent node
	#Variables written in
	$Label.text = "Hello, world."
	$Label.modulate = Color.INDIGO
	
func _input(event):
	print(variable2)
	#if statements begin with head ending w/ colon, and indented body
	if event.is_action_pressed("red_action"):
		$Label.modulate = Color.DARK_SALMON
		variable1 += 1
		if variable1 >= 60:
			variable1 = 60
			print("That is all you get!")
		else:
			print(variable1)
	if event.is_action_released("red_action"):
		$Label.modulate = Color.INDIGO
	pass
