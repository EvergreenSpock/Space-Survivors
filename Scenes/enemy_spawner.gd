extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_radius: float = 200.0
@export var max_enemies: int = 10

var spawn_timer := 1.0
var current_enemies: Array = []

@onready var player := get_tree().get_root().get_node_or_null("Main Scene/Player")

func _process(delta: float) -> void:
	# Update player reference in case it was freed and respawned
	if not is_instance_valid(player):
		player = get_tree().get_root().get_node_or_null("Main Scene/Player")

	if not is_instance_valid(player):
		return  # Player doesn't exist yet — don't spawn anything

	spawn_timer += delta

	if spawn_timer >= spawn_interval and current_enemies.size() < max_enemies:
		spawn_timer = 0.0
		spawn_enemy()

	current_enemies = current_enemies.filter(func(e): return is_instance_valid(e))

func spawn_enemy():
	if enemy_scene == null:
		push_warning("Enemy scene not assigned!")
		return

	if not is_instance_valid(player):
		push_warning("Player not found.")
		return

	var enemy = enemy_scene.instantiate()

	var offset = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		2.0,
		randf_range(-spawn_radius, spawn_radius)
	)

	var spawn_position = player.global_position + offset
	enemy.global_position = spawn_position

	var enemy_container = get_tree().get_current_scene().get_node("EnemyContainer")
	if not enemy_container:
		push_error("EnemyContainer not found!")
		return

	enemy_container.add_child(enemy)
	current_enemies.append(enemy)

	print("Enemy initial position (pre-add): ", spawn_position)
