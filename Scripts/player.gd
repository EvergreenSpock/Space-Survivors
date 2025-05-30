extends "res://Scripts/ship.gd"


# Default stats/settings (could export these and allow them to be changed with upgrades)
var default_speed := 14
var boosted_speed := 28
var rotation_speed := 8
var max_fuel = 100

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

signal health_depleted(max_health, remaining)

# The last movement or aim direction input by the player

func _ready():
	leftBoostTrail = get_node("Pivot/ShipMesh/LeftEngineBoostTrail")
	rightBoostTrail = get_node("Pivot/ShipMesh/RightEngineBoostTrail")
	$PlayerCamera/InGameUI/Retry.hide()
	max_health = 150 #+ Global.max_health_upgrade
	health = 150
	shield = 75

func _physics_process(_delta):
	look_at_cursor()
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
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

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	global_position.y = 2.0

	# Moving the Character
	# Smoothly interpolate current velocity toward target
	velocity = velocity.lerp(target_velocity, .5)
	move_and_slide()

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
	
func apply_damage(amount: int) -> void:
	var remaining := amount
	health_depleted.emit(max_health, remaining)
	# Shields absorb first
	if shield > 0: 
		remaining = max(0, amount - shield)
		shield = max(shield - amount, 0)

	# Health takes remaining
	if remaining > 0:
		health = max(health - remaining, 0)
	
	# Visual feedback always
	flash_damage()
	print("Ship took ", amount, " damage! Remaining health: ", health)
	emit_stats()
		# Now check death
	if health == 0:
		death()
	
func look_at_cursor():
	var raycast_length = 1000
	var viewport := $PlayerCamera/SubViewportContainer/SubViewport
	var camera := viewport.get_node("PlayerCamera")  # Adjust path if necessary

	var mouse_position = viewport.get_mouse_position()  # LOCAL to the SubViewport
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	var ray_to = ray_origin + ray_direction * raycast_length
	
	# Perform physics raycast
	var space_state = get_world_3d().get_direct_space_state()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_to
	params.collision_mask = 1  # Make sure this matches the target layer
	var result = space_state.intersect_ray(params)
	
	var target_position: Vector3

	if result:
		target_position = result.position
		if has_node("mouse_select"):
			$mouse_select.global_transform.origin = result.position
	else:
		# Fallback to horizontal plane
		var plane_y = global_position.y
		var plane = Plane(Vector3.UP, plane_y)
		var hit = plane.intersects_ray(ray_origin, ray_to)
		if hit == null:
			return
		target_position = hit

	# Rotate the pivot to face the target position
	# Force target position to match pivot Y level
	target_position.y = $Pivot.global_position.y
	# Now look only in the horizontal plane
	$Pivot.look_at(target_position, Vector3.UP)
