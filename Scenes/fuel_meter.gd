extends ColorRect

@onready var meter_bar = $"."
@onready var player = $"../../"

func _ready():
	meter_bar.size.x = player.fuel_level

func _process(delta: float) -> void:
	meter_bar.size.x = player.fuel_level
