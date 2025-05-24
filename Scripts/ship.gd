extends CharacterBody3D

@export var max_health := 100
@export var max_shield := 100

var health := max_health
var shield := max_shield

signal stats_changed(current_health: int, max_health: int, current_shield:int, max_shield: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_stats()

func apply_damage(amount: int) -> void:
	var remaining := amount

	if shield > 0: 
		remaining = max(0, amount - shield)
		shield = max(shield - amount, 0)
	if remaining > 0:
		health = max(health - remaining, 0)
	emit_stats()

func emit_stats() -> void:
	stats_changed.emit(health, max_health, shield, max_shield)
