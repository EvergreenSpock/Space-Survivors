extends "res://Scripts/ship.gd"

@export var detection_radius := 25.0
@export var fire_cooldown := 1.5
@export var bullet_scene: PackedScene
@export var speed := 5

@onready var player = get_node("../Player")
var can_fire := true


func ai_get_direction():
	return player.position - self.position
func ai_move():
	var direction = ai_get_direction()
	velocity = direction.normalized() * speed
	move_and_slide()
func _process(_delta):
	ai_move()
	var target_basis = Basis().looking_at(ai_get_direction().normalized(), Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, 3 * get_process_delta_time())
