extends Control

@onready var hp_bar = $HpBar
@onready var player = $"../.."
@onready var set_hp_bar_length = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_health_depleted(max_health, remaining) -> void:
	var ratio := float(remaining) / float(max_health)
	hp_bar.scale.x = 10.0 * ratio
	print("Updated HP bar scale:", hp_bar.scale.x)
