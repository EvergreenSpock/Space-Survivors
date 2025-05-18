extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

# The downward acceleration when in the air, in meters per second squared.
#@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

var leftBoostTrail: GPUParticles3D
var rightBoostTrail: GPUParticles3D

#Bullets
var bullet = load("res://Scenes/bullet_pew_pew.tscn")
var instance
var instance2
var bullet_cooldown_is_ready:bool = true

@onready var gunBarrel = $"Pivot/Pew Pew/RayCast3D"
@onready var gunBarrel2 = $"Pivot/Pew Pew 2/RayCast3D"

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
	#if Input.is_action_just_pressed("pew_pew_button"):
	if bullet_cooldown_is_ready:
		bullet_cooldown_is_ready = false
		$BulletCooldown.start()
		instance = bullet.instantiate()
		instance2 = bullet.instantiate()
		instance.position = gunBarrel.global_position
		instance2.position = gunBarrel2.global_position
		instance.transform.basis = gunBarrel.global_transform.basis
		instance2.transform.basis = gunBarrel2.global_transform.basis
		get_parent().add_child(instance)
		get_parent().add_child(instance2)
		
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
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y

	# Moving the Character
	velocity = target_velocity
	move_and_slide()


func _on_bullet_cooldown_timeout() -> void:
	bullet_cooldown_is_ready = true; # Replace with function body.
