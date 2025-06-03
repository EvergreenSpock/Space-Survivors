extends "res://Scripts/ship.gd"

@export var desired_distance := 20.0
@export var distance_tolerance := 5.0
@export var max_distance := 40.0
@export var speed := 30

@onready var gunBarrel = $"Pew Pew/RayCast3D"
@onready var player = get_tree().get_root().get_node_or_null("Main Scene/Player")
@onready var dating_sim_scene = get_tree().get_root().get_node_or_null("Main Scene/Player/DatingSim")
var can_fire := true
var bullet = load("res://Scenes/heavy_bullet.tscn")
var instance
var bullet_cooldown_is_ready: bool = true



func _ready() -> void:
	xp_orb_scene = preload("res://Scenes/xp_orb.tscn")
	#print("Enemy ready at: ", global_position)

func ai_get_direction():
	if not is_instance_valid(player):
		can_fire = false
		return Vector3.ZERO

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance < desired_distance - distance_tolerance:
		can_fire = false
		return -to_player
	elif distance <= desired_distance + distance_tolerance:
		can_fire = true
		return Vector3.ZERO
	elif distance <= max_distance:
		can_fire = true
		return to_player
	else:
		can_fire = false
		return to_player

func ai_move():
	var direction = ai_get_direction()
	if direction != Vector3.ZERO:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector3.ZERO

func _process(delta):
	if not is_instance_valid(player):
		return  # Player is gone — skip processing

	ai_move()

	if !is_facing_player() and can_fire:
		face_player(3.0, delta)

	var direction = ai_get_direction()
	if direction != Vector3.ZERO:
		var target_basis = Basis.looking_at(direction.normalized(), Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, 3 * delta)

	global_position.y = 2.0

	if bullet_cooldown_is_ready and can_fire and is_facing_player():
		bullet_cooldown_is_ready = false
		$BulletCooldown.start()
		instance = bullet.instantiate()
		instance.position = gunBarrel.global_position
		instance.transform.basis = gunBarrel.global_transform.basis
		get_tree().current_scene.add_child(instance)

func _on_bullet_cooldown_timeout() -> void:
	bullet_cooldown_is_ready = true

func is_facing_player(threshold: float = 1.0) -> bool:
	if not is_instance_valid(player):
		return false

	var to_player = (player.global_position - global_position).normalized()
	var forward = -global_transform.basis.z.normalized()
	var alignment = forward.dot(to_player)

	return alignment >= threshold

func face_player(turn_speed := 3.0, delta := 1.0) -> void:
	if not is_instance_valid(player):
		return

	var to_player = (player.global_position - global_position).normalized()
	var target_basis = Basis.looking_at(to_player, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, turn_speed * delta)

func death() -> void:
	var orb = xp_orb_scene.instantiate()
	get_tree().get_root().add_child(orb)
	orb.global_position = global_position
	Global.player_score += 25
	queue_free()
	
func apply_damage(amount: int) -> void:
	get_tree().paused = true
	$"../Player/PlayerCamera/InGameUI".hide()
	$"../Player/PlayerCamera/FuelMeterBar".hide()
	$"../Player/PlayerCamera/HealthBar".hide()
	dating_sim_scene.show()
	var remaining := amount
	
	
	# Shields absorb first
	if shield > 0: 
		remaining = max(0, amount - shield)
		shield = max(shield - amount, 0)

	# Health takes remaining
	if remaining > 0:
		health = max(health - remaining, 0)

	# Visual feedback always
	flash_damage()
	

	#print("Ship took ", amount, " damage! Remaining health: ", health)

	emit_stats()

	# Now check death
	if health == 0:
		death()
