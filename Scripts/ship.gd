extends CharacterBody3D

@export var max_health := 1000
@export var max_shield := 100

@onready var mesh: Node3D = get_node_or_null("Pivot/ShipMesh") \
	if get_node_or_null("Pivot/ShipMesh") != null else get_node_or_null("ShipMesh")

@onready var hitflashanim: AnimationPlayer = get_node_or_null("Pivot/ShipMesh/hitflashanim") \
	if get_node_or_null("Pivot/ShipMesh/hitflashanim") != null else get_node_or_null("ShipMesh/hitflashanim")

var health := max_health
var shield := max_shield

signal stats_changed(current_health: int, max_health: int, current_shield: int, max_shield: int)

func _ready() -> void:
	emit_stats()

func apply_damage(amount: int) -> void:
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
	

	print("Ship took ", amount, " damage! Remaining health: ", health)

	emit_stats()

	# Now check death
	if health == 0:
		queue_free()

func flash_damage():
	hitflashanim.play("hit")
	#if not mesh:
		#return
#
	#var shader_material := mesh.get_active_material(0) as ShaderMaterial
	#if shader_material:
		#shader_material.set_shader_parameter("intensity", 0.8)
		#await get_tree().create_timer(0.8).timeout
		#shader_material.set_shader_parameter("intensity", 0.0)

func emit_stats() -> void:
	stats_changed.emit(health, max_health, shield, max_shield)
