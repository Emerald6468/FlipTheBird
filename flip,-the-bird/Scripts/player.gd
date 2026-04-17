extends CharacterBody3D

#Basics
@export var Speed = 20.0
@export var Force = 90
const JUMP_VELOCITY = 25
@export var Max_Velocity = 120
var current_velocity = Force

#Slope
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
var is_flipping = false
var axis_speed = 1.0

#Obstacle Collision
@onready var collision_checker: Area3D = $CollisionShape3D/Model/CollisionChecker
var dont_check = false
var fragile = false
var just_hit = false
#Maybe player rotates faster per full spin? 

@export var gravity_modifier = 1.0

#FUNCTIONS
#Only runs on start
func _ready() -> void:
	current_velocity = -Force

#Increases your speed going down slopes
func SlopeSliding():
	if slope_collider.is_colliding():
		slope_hit = slope_collider.get_collision_point(0)
		slope_angle = get_floor_angle()
		slope_angle = rad_to_deg(slope_angle)
		#print("slope angle " + str(slope_angle))
		slope_normal = get_floor_normal()
		var yInverse = 1 - slope_normal.y
		var speed_increase = yInverse * slope_normal.z * angle_power * 1000
		if speed_increase > 0: speed_increase = 0.3
		#print("speed increase " + str(speed_increase))
		current_velocity += speed_increase

#All the reflection code
func rotation_math():
	angle_power = 1.0
	#TO DO: Allow rotation only when midair
	var current_angle = model.get_rotation().x
	#print(current_angle)
	
	#Commented code below causes player to launch out of bounds
	if current_angle > 90 or current_angle < -90:
		current_angle = -90
	if !is_flipping: angle_power = (current_angle*.2)+1
	#fall faster when looking down
	if current_angle < 90 and current_angle > 0:
		if !is_flipping:
			print("not flipping")
			set_floor_snap_length(1.0)
		#angle_power *= 2
	else: 
		set_floor_snap_length(0.0)
		
	
		
	#For every 360 midair, add to score
	#Because current_angle can't increase past ~1.5, this if statement is a bandaid
	#solution for measuring rotations totaling approximately 360
	if current_angle > 1.4 && current_angle <1.6:
		#print("Points received!")

		total_flips += 1
		#TO DO: Create higher node for Global.gd to be embeded
		#Code below will not function until Global.gd is actually used
	
		#print("Total Score: "+ str($Global.score))
	#FOR LATER: Add multiplier from fish/stones to scoring

#Fragile State that can make you game over
func fragile_timer():
	if just_hit:
		#SWAP FOR DIZZY TIMER
		just_hit = false
		await get_tree().create_timer(10).timeout
		fragile = false

#Interactions with obstacles
func check_collisions():
	if fragile: fragile_timer()
	var area_list = collision_checker.get_overlapping_areas()
	if collision_checker.has_overlapping_bodies() and !dont_check:
		for area in area_list:
			if area.is_in_group("Obstacle"):
				#game over trigger
				if fragile: Global.game_over = true
				dont_check = true
				velocity.z = -Force
				print("hit something")
				fragile = true
				just_hit = true
				#SWAP FOR AWAIT WHEN THE SPIN ANIMATION FINISHES
				await get_tree().create_timer(2).timeout
				print("can get hit again")
				dont_check = false

#Running every frame main function
func _physics_process(delta: float) -> void: 
	check_collisions()
	Global.is_fragile = fragile
	current_velocity += .1
	if current_velocity >= 0: current_velocity = -Force
	if current_velocity < -Max_Velocity: current_velocity = -Max_Velocity
	Global.forward_velocity = current_velocity
	previous_angle = model.get_rotation().x
	#W and S rotate, A and D steer
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#Left and right
		velocity.x = direction.x * Speed
		#Rotate
		var air_change = 1.0
		if !is_on_floor(): air_change = 4.0
		var rad_change = (deg_to_rad(input_dir.y)*4.5)* axis_speed
		#var rad_change = deg_to_rad(input_dir.y)*2.5 * air_change

		model.rotate_x(rad_change)
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	if input_dir.y != 0: 
		print("we flip")
		is_flipping = true
	else: 
		print(str(input_dir.y))
		is_flipping = false
	call_deferred("rotation_math")
	#Gravity
	if is_on_floor():
		#Set total_flips back to 0
		for i in total_flips:
			Global.score += 1
		total_flips = 0
		axis_speed = 1.0
		SlopeSliding()
	else:
		velocity += (get_gravity() * gravity_modifier) * delta
		#Commented code below causes player to launch out of bounds (overflows velocity.y)
		#Note: As result, Flip will slowly lose momentum, but regain it when near ~(-10)
		velocity.y *= angle_power
	#Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	move_and_slide()
	Global.velocity = current_velocity
