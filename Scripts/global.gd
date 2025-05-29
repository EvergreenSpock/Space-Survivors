extends Node

var player_exp = 0
var player_level = 1
var exp_threshold = [0, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, 102400, 204800, 409600]
var player_score = 0 
var cursor_texture = preload("res://assets/cursor.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(80, 80))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
