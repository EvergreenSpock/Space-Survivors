extends Control

@onready var left_card_weapon_title = $LeftCard/WeaponTitle
@onready var middle_card_weapon_title = $MiddleCard/WeaponTitle
@onready var right_card_weapon_title = $RightCard/WeaponTitle

var card_title = []

var rng = RandomNumberGenerator.new()

var rarities = {
	0: "Common",
	1: "Uncommon",
	2: "Rare",
	3: "Legendary"
}

var early_upgrades = [
	"Health Upgrade",
	"Fuel Capacity",
	"Basic Weapon Damage"
]

var advanced_upgrades = [
	"Shield System",
	"Shotgun Weapon",
	"Ship Roll"
]

var shotgun_upgrades = [
	"Shotgun Fire-Rate",
	"Shotgun Damage",
	"Shotgun Bullet Speed"
]

var ship_roll_upgrades = [
	"Roll Cooldown Reduction",
	"Roll Burst Effect"
]

var shield_upgrades = [
	"Shield Strength",
	"Shield Recharge Rate"
]

func _ready() -> void:
	card_title = [
		left_card_weapon_title,
		middle_card_weapon_title,
		right_card_weapon_title
	]

func _on_reward_screen_visibility_changed() -> void:
	var level = Global.player_level
	for i in range(card_title.size()):
		var upgrade = get_random_upgrade(level)
		var rarity = rarities[rng.randi_range(0, 3)]
		card_title[i].text = "%s %s" % [rarity, upgrade]

func get_random_upgrade(level: int) -> String:
	var available_upgrades = early_upgrades.duplicate()

	if level >= 3:
		available_upgrades += advanced_upgrades

	if level >= 4:
		available_upgrades += shotgun_upgrades + shield_upgrades + ship_roll_upgrades

	return available_upgrades[rng.randi_range(0, available_upgrades.size() - 1)]
