extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

# The downward acceleration when in the air, in meters per second squared.
#@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

var leftBoostTrail: GPUParticles3D
var rightBoostTrail: GPUParticles3D

func _ready():
	leftBoostTrail = get_node("Pivot/MicroRecon/LeftEngineBoostTrail")
	rightBoostTrail = get_node("Pivot/MicroRecon/RightEngineBoostTrail")

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	# If boosting, increase the speed & turn on particles
	if Input.is_action_pressed("boost"):
		speed = 28
		
		leftBoostTrail.emitting = true
		rightBoostTrail.emitting = true
		
	else: # could probably do this better and not have run every update frame
		speed = 14
		
		leftBoostTrail.emitting = false
		rightBoostTrail.emitting = false


	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
