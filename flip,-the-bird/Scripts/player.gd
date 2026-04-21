extends CharacterBody3D

@export var Speed = 20.0
@export var Force = 100
const JUMP_VELOCITY = 25

#Slope
var is_gripping = false
var ignore = false
@onready var slope_collider: ShapeCast3D = %SlopeCollider
var slope_hit: Vector3
var slope_angle
var slope_normal: Vector3

#Player angle
@onready var model: Node3D = $CollisionShape3D/Model
var previous_angle
var angle_power = 1.0
var total_flips = 0
var axis_speed = 1.0


@export var gravity_modifier = 5.0

func _ready() -> void:
	velocity.z = -Force
	set_floor_snap_length(1.0)

func SlopeSliding():
	if slope_collider.is_colliding():
		if !ignore:
			is_gripping = true
		slope_hit = slope_collider.get_collision_point(0)
		slope_angle = get_floor_angle()
		slope_angle = rad_to_deg(slope_angle)
		print("slope angle " + str(slope_angle))
		slope_normal = get_floor_normal()
		var yInverse = 1 - slope_normal.y
		var speed_increase = yInverse * slope_normal.z * angle_power * 1000
		if speed_increase > 0: speed_increase = 0.3
		print("speed increase " + str(speed_increase))
		velocity.z += speed_increase

func rotation_math():
	#TO DO: Allow rotation only when midair
	var current_angle = model.get_rotation().x
	print(current_angle)
	
	#Commented code below causes player to launch out of bounds
	#if current_angle > 90 or current_angle < -90:
		#current_angle = -90
	angle_power = (current_angle*.2)+1
	#For every 360 midair, add to score
	#Because current_angle can't increase past ~1.5, this if statement is a bandaid
	#solution for measuring rotations totaling approximately 360
	if current_angle > 1.4 && current_angle <1.6:
		print("Points received!")
		total_flips += 1
		axis_speed += 0.5
		#TO DO: Create higher node for Global.gd to be embeded
		#Code below will not function until Global.gd is actually used
	#for i in total_flips:
		#$Global.score += 50
		#print("Total Score: "+ str($Global.score))
	#FOR LATER: Add multiplier from fish/stonse to scoring

		
func _physics_process(delta: float) -> void:
	velocity.z += .1
	if velocity.z >= 0: velocity.z = -100
	Global.forward_velocity = velocity.z
	previous_angle = model.get_rotation().x
	#W and S rotate, A and D steer
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#Left and right
		velocity.x = direction.x * Speed
		#Rotate
		var rad_change = (deg_to_rad(input_dir.y)*4.5)* axis_speed
		model.rotate_x(rad_change)
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	rotation_math()
	#Gravity
	if is_on_floor():
		#Set total_flips back to 0 and axis_speed back to 1
		total_flips = 0
		axis_speed = 1.0
		SlopeSliding()
	else:
		if is_gripping:
			pass
			#print("test")
			#apply_floor_snap()
		velocity += (get_gravity() * gravity_modifier) * delta
	#Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()
