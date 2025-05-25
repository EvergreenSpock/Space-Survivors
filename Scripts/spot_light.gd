extends SpotLight3D

@export var player_path: NodePath
@export var follow_distance := 4.0
@export var follow_height := 3.0
@export var smoothing := 1

var player: Node3D

func _ready():
	player = get_node("../..")

func _process(_delta):
	if not player:
		return

	var player_pos = player.global_transform.origin
	var direction_to_player = player_pos - global_transform.origin

	# Set the spotlight position (hovering behind or above the player)
	var desired_position = player_pos - direction_to_player.normalized() * follow_distance
	desired_position.y += follow_height

	# Smooth movement
	global_transform.origin = global_transform.origin.lerp(desired_position, smoothing)

	# Point the spotlight toward the player
	var spotlight_pos = global_transform.origin
	var target_pos = player.global_transform.origin
	var direction = target_pos - spotlight_pos

	var up_vector = Vector3.UP
	if abs(direction.normalized().dot(Vector3.UP)) > 0.99:
		up_vector = Vector3.FORWARD  # Use a different up vector to avoid colinearity

	look_at(target_pos, up_vector)
