extends ProgressBar

@onready var reward_screen = get_tree().get_root().get_node_or_null("Main Scene/Player/PlayerCamera/RewardScreen")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_exp_bar()
	reward_screen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_exp_bar()
	check_level_up()

func gain_exp(amount: int): 
	Global.player.exp += amount
	while Global.player.exp >= Global.exp_threshold[Global.player_level]:
		Global.player_exp -= Global.exp_threshold[Global.player_level]
		Global.player_level += 1
	update_exp_bar()

func update_exp_bar():
	$".".max_value = Global.exp_threshold[Global.player_level]
	$".".value = Global.player_exp

func check_level_up():
	while Global.player_exp >= Global.exp_threshold[Global.player_level]:
		Global.player_exp -= Global.exp_threshold[Global.player_level]
		Global.player_level += 1 
		get_tree().paused = true
		reward_screen.show()
