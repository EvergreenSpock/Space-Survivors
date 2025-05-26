extends CharacterBody3D

@export var xp_value: int = 10
@export var pickup_range: float = 1.0
@export var move_speed: float = 5.0

var player

signal xp_collected(amount: int)

func _ready():
	player = $"."

func _physics_process(delta):
	if not is_instance_valid(player):
		return

	var distance = global_position.distance_to(player.global_position)

	# Move toward player if close
	if distance < pickup_range:
		global_position = global_position.move_toward(player.global_position, move_speed * delta)

	# Auto-collect if super close
	if distance < 0.5:
		emit_signal("xp_collected", 5)
		queue_free()
