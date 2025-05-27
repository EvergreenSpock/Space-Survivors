extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score()

func update_score():
	text="Score: " +str(Global.player_score)
