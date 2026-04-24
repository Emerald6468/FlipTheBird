extends Node3D
@onready var rock_1: Node3D = $texturedrock1
@onready var rock_2: Node3D = $texturedrock2
@onready var rock_3: Node3D = $texturedrock3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock_1.hide()
	rock_2.hide()
	rock_3.hide()
	var num = round(randf_range(.5,3))
	print(str(num))
	match num:
		1.0:
			rock_1.show()
		2.0:
			rock_2.show()
		3.0:
			rock_3.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
