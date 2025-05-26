extends "res://Scripts/ship.gd"

@export var desired_distance := 40.0
@export var distance_tolerance := 3.0
@export var fire_cooldown := 1.5
@export var speed := 10

@onready var gunBarrel = $"Pew Pew/RayCast3D"
@onready var player := get_node("../Player")
var can_fire := true
var bullet = load("res://Scenes/heavy_bullet.tscn")
var instance
var bullet_cooldown_is_ready:bool = true

func _ready() -> void:
	xp_orb_scene = load("res://Scenes/xp_orb.tscn")

func ai_get_direction():
	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance < desired_distance - distance_tolerance:
		can_fire = false
		return -to_player
	elif distance > desired_distance + distance_tolerance:
		can_fire = true
		return to_player
	else:
		can_fire = true
		# In sweet spot — stay still
		return Vector3.ZERO

func ai_move():
	var direction = ai_get_direction()
	if direction != Vector3.ZERO:
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector3.ZERO

func _process(_delta):
	ai_move()
	var direction = ai_get_direction()
	if direction != Vector3.ZERO:
		var target_basis = Basis().looking_at(direction.normalized(), Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, 3 * get_process_delta_time())
		global_position.y = 2.0
	if bullet_cooldown_is_ready and can_fire:
		bullet_cooldown_is_ready = false
		$BulletCooldown.start()
		instance = bullet.instantiate()
		instance.position = gunBarrel.global_position
		instance.transform.basis = gunBarrel.global_transform.basis
		get_tree().current_scene.add_child(instance)

func _on_bullet_cooldown_timeout() -> void:
	bullet_cooldown_is_ready = true; # Replace with function body.
