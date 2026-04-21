extends CharacterBody3D

#Basics
@export var Speed = 20.0
@export var Force = 120
@export var Max_Velocity = 300
var current_velocity = Force

#Slope
var ignore = false
@onready var slope_collider: ShapeCast3D = %SlopeCollider
var slope_hit: Vector3
var slope_angle
var slope_normal: Vector3

#Gaining Height
const JUMP_VELOCITY = 25
var just_leaped = false
var slope_points = 0
var nothing_around = false
var touching_hill = false
var going_up = false
@export var height_shrinker = 0.001

#Player angle
@onready var model: Node3D = $CollisionShape3D/Model
var previous_angle
var angle_power = 1.0
var total_flips = 0
var is_flipping = false
var axis_speed = 1.0

#Obstacle Collision
@onready var collision_checker: Area3D = $CollisionShape3D/Model/CollisionChecker
@onready var ground_checker: Area3D = $GroundChecker
var close_to_hill = false
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
		var speed_increase = yInverse * slope_normal.z * 1000
		if speed_increase > 0: 
			going_up = true
			speed_increase = 0.3
		else: going_up = false
		#print("speed increase " + str(speed_increase))
		current_velocity += speed_increase

#All the reflection code
func rotation_math():
	angle_power = 1.0
	var current_angle = rad_to_deg(model.get_rotation().x)
	#print(current_angle)
	
	#Commented code below causes player to launch out of bounds
	#if current_angle > 90 or current_angle < -90:
	#	current_angle = -90
	if !is_flipping: angle_power = (current_angle*.01)+1
	
	#gain slope_points when sliding up
	if current_angle < 0 and current_angle >= -90 and going_up and close_to_hill:
		slope_points += 1
	else: print("ang:"+str(current_angle)+"up?:"+str(going_up)+"touching nothing:"+str(nothing_around)+"hill:"+str(close_to_hill)+"upvelocity:"+str(velocity.y))
	#fall faster when looking down
	if current_angle < 90 and current_angle > 0 and !is_flipping:
		if close_to_hill:
			print("snap")
			set_floor_snap_length(1.0)
		velocity.y -= 1 * angle_power * 2
	else: 
		
		set_floor_snap_length(0.0)
		
	
		
	#For every 360 midair, add to score
	#Because current_angle can't increase past ~1.5, this if statement is a bandaid
	#solution for measuring rotations totaling approximately 360
	if current_angle > 1.4 && current_angle <1.6:
		#print("Points received!")

		total_flips += 1
		axis_speed += 1
	
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
	var body_list = collision_checker.get_overlapping_bodies()
	if collision_checker.has_overlapping_areas() and !dont_check:
		nothing_around = false
		for area in area_list:
			if area.is_in_group("Obstacle"):
				#game over trigger
				if fragile: Global.game_over = true
				dont_check = true
				current_velocity = -Force
				print("hit something")
				fragile = true
				just_hit = true
				#SWAP FOR AWAIT WHEN THE SPIN ANIMATION FINISHES
				await get_tree().create_timer(2).timeout
				print("can get hit again")
				dont_check = false
	elif collision_checker.has_overlapping_bodies():
		#print(str(body_list))
		nothing_around = false
		#for body in body_list:
		#	if body.is_in_group("Hill"): touching_hill = true
		#	else: touching_hill = false
	else: nothing_around = true
	
	var ground_body_list = ground_checker.get_overlapping_bodies()
	if ground_checker.has_overlapping_bodies():
		for body in ground_body_list:
			if body.is_in_group("Hill"): 
				close_to_hill = true
				print("close to hill")
	else: close_to_hill = false 
	if is_on_floor() and !close_to_hill: slope_points = 0
	

#When you leap
func leaping():
	if nothing_around and just_leaped == false:
		print("LEAP")
		just_leaped = true
		var height_gain = 0.0
		if slope_points != 0:
			height_gain = (-1 * current_velocity * height_shrinker) + slope_points
			velocity.y += height_gain
			print("slope points: " + str(slope_points))
			slope_points = 0

#Running every frame main function
func _physics_process(delta: float) -> void: 
	check_collisions()
	leaping()
	Global.is_fragile = fragile
	if !is_on_floor(): current_velocity += .01
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
		is_flipping = true
	else: 
		is_flipping = false
	
	call_deferred("rotation_math")
	#Gravity
	if is_on_floor():
		just_leaped = false
		#Set total_flips back to 0
		for i in total_flips:
			Global.score += 1
		total_flips = 0
		axis_speed = 1.0
		call_deferred("SlopeSliding")
	else:
		velocity += (get_gravity() * gravity_modifier) * delta
		#Commented code below causes player to launch out of bounds (overflows velocity.y)
		#Note: As result, Flip will slowly lose momentum, but regain it when near ~(-10)
		#velocity.y += angle_power
		if velocity.y > 50: velocity.y = 50
		elif velocity.y < -50: velocity.y = -50
	#Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	move_and_slide()
	Global.velocity = current_velocity
