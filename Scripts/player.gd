extends "res://Scripts/ship.gd"


# Default stats/settings (could export these and allow them to be changed with upgrades)
var default_speed := 14
var boosted_speed := 28
var rotation_speed := 8
var max_fuel = 100
#var xp: int = 0

# How fast the player moves in meters per second.
@export var speed = default_speed

# Player stats
@export var fuel_level = max_fuel
@export var fuel_exhausted = false

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
var can_fire := true

#Bullet raycasts for the primary gun. Should probably separated into a separate class so that we can just import the classes when the upgrade and change weapons.
@onready var gunBarrel = $"Pivot/Pew Pew/RayCast3D"
@onready var gunBarrel2 = $"Pivot/Pew Pew 2/RayCast3D"

# The last movement or aim direction input by the player

func _ready():
	leftBoostTrail = get_node("Pivot/ShipMesh/LeftEngineBoostTrail")
	rightBoostTrail = get_node("Pivot/ShipMesh/RightEngineBoostTrail")
	$PlayerCamera/InGameUI/Retry.hide()

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
	if Input.is_action_pressed("boost") and fuel_level > 0 and not fuel_exhausted:
		
		speed = boosted_speed
		
		leftBoostTrail.emitting = true
		rightBoostTrail.emitting = true
		
		fuel_level -= 1
		
	# If boosting and run the fuel to 0, temporarily prevent boosting
	elif Input.is_action_pressed("boost") and fuel_level < 1:
		fuel_exhausted = true
		speed = default_speed
		
		leftBoostTrail.emitting = false
		rightBoostTrail.emitting = false
		
		$FuelExhaustion.start()
		
	elif Input.is_action_pressed("interact") and $PlayerCamera/InGameUI/Retry.visible:
		queue_free()
		get_tree().reload_current_scene()
		
	else: # could probably do this better and not have run every update frame
		speed = default_speed
		
		leftBoostTrail.emitting = false
		rightBoostTrail.emitting = false
		
		if fuel_level < max_fuel:
			fuel_level += 1


	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var current_basis = $Pivot.global_transform.basis
		var target_basis = Basis.looking_at(direction, Vector3.UP)
		$Pivot.global_transform.basis = current_basis.slerp(target_basis, rotation_speed * _delta)



	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	global_position.y = 2.0

	# Vertical Velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y

	# Moving the Character
	# Smoothly interpolate current velocity toward target
	velocity = velocity.lerp(target_velocity, 0.1)
	move_and_slide()


#func _on_xp_collected(amount: int) -> void:
	#xp += amount
	#print("XP collected! New total: ", xp)

func _on_bullet_cooldown_timeout() -> void:
	if can_fire:
		bullet_cooldown_is_ready = true; # Replace with function body.


func _on_fuel_exhaustion_timeout() -> void:
	fuel_exhausted = false
func death() -> void:
	can_fire = false
	$PlayerCamera/InGameUI/Retry.show()
	$".".hide()
	#await get_tree().create_timer(1).timeout
	#queue_free()
