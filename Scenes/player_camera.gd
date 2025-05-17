extends Node3D

@export var player_path: NodePath
@export var distance: float = -5.0
@export var height: float = 10.0
@export var smoothing: float = 1

var player: Node3D

func _ready():
	player = get_node("../../..") # or use export path if you'd prefer

func _process(_delta):
	if not player:
		return

	# Get the player's position and facing direction
	var player_pos = player.global_transform.origin
	var back_direction = -player.global_transform.basis.z.normalized()

	# Calculate desired camera position behind and above the player
	var target_position = player_pos + back_direction * distance
	target_position.y += height

	# Smooth follow
	global_transform.origin = global_transform.origin.lerp(target_position, smoothing)
	
	# Make the camera look at the player (optional)
	look_at(player_pos, Vector3.UP)
