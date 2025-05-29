extends Node

var player_exp = 0
var player_level = 1
var exp_threshold = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, 102400, 204800, 409600]
var player_score = 0 
var cursor_texture = preload("res://assets/cursor.png")
var max_health_upgrade := 0
var max_fuel_upgrade := 0
var start_gun_damage_percentage_upgrade := 0.0
var shield_upgrade_bool : bool = false
var shotgun_upgrade_bool : bool = false
var evasive_upgrade_bool : bool = false
var shotgun_fire_rate_upgrade := 0.0
var shotgun_damage_percentage_upgrade := 0.0
var shotgun_bullet_speed_upgrade := 0
var roll_cooldown_reduction := 0.0
var explosive_roll_burst_bool_upgrade := false
var max_shield_percentage_upgrade := 0.0
var faster_shield_regen_cooldown_upgrade = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(80, 80))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
