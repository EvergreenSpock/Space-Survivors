extends Control

@onready var left_card = $LeftCard
@onready var middle_card = $MiddleCard
@onready var right_card = $RightCard

@onready var left_card_weapon_title = $LeftCard/WeaponTitle
@onready var middle_card_weapon_title = $MiddleCard/WeaponTitle
@onready var right_card_weapon_title = $RightCard/WeaponTitle

@onready var left_card_weapon_desc = $LeftCard/WeaponDescription
@onready var middle_card_weapon_desc = $MiddleCard/WeaponDescription
@onready var right_card_weapon_desc = $RightCard/WeaponDescription

var rng = RandomNumberGenerator.new()

var rarities = {
	"Common": Color("ffffff"),
	"Uncommon": Color("55ff55"),
	"Rare": Color("5599ff"),
	"Legendary": Color("ffcc00")
}

var rarity_weights = {
	"Common": 60,
	"Uncommon": 25,
	"Rare": 12,
	"Legendary": 3
}

var early_upgrades = [
	{"name": "Health Upgrade", "desc": "+25 Max Health"},
	{"name": "Fuel Capacity", "desc": "+20 Max Fuel"},
	{"name": "Basic Weapon Damage", "desc": "+10% Bullet Damage"}
]

var advanced_upgrades = [
	{"name": "Shield System", "desc": "Grants regenerating shields"},
	{"name": "Shotgun Weapon", "desc": "Unlocks a powerful short-range weapon"},
	{"name": "Ship Roll", "desc": "Gain evasive roll movement"}
]

var shotgun_upgrades = [
	{"name": "Shotgun Fire-Rate", "desc": "Increases shotgun fire rate"},
	{"name": "Shotgun Damage", "desc": "+20% Shotgun Damage"},
	{"name": "Shotgun Bullet Speed", "desc": "Faster shotgun bullets"}
]

var ship_roll_upgrades = [
	{"name": "Roll Cooldown Reduction", "desc": "Roll more frequently"},
	{"name": "Roll Burst Effect", "desc": "Explosion after roll"}
]

var shield_upgrades = [
	{"name": "Shield Strength", "desc": "+25% Shield Capacity"},
	{"name": "Shield Recharge Rate", "desc": "Faster shield recharge"}
]

var card_slots = []

func _ready() -> void:
	rng.randomize()
	await get_tree().process_frame
	card_slots = [
		{"title": left_card_weapon_title, "desc": left_card_weapon_desc, "node": left_card},
		{"title": middle_card_weapon_title, "desc": middle_card_weapon_desc, "node": middle_card},
		{"title": right_card_weapon_title, "desc": right_card_weapon_desc, "node": right_card}
	]

func _on_reward_screen_visibility_changed() -> void:
	_populate_cards()

func _populate_cards():
	if card_slots.size() < 3:
		push_error("Card slots not initialized yet!")
		return

	for i in range(3):
		var upgrade = get_random_upgrade(Global.player_level)
		var rarity_key = get_weighted_rarity()
		var rarity_color = rarities[rarity_key]

		if card_slots[i]["title"] != null:
			card_slots[i]["title"].text = "%s: %s" % [rarity_key, upgrade["name"]]
		if card_slots[i]["desc"] != null:
			card_slots[i]["desc"].text = upgrade["desc"]
		if card_slots[i]["node"] != null:
			card_slots[i]["node"].modulate = rarity_color

func get_random_upgrade(level: int) -> Dictionary:
	var available_upgrades = early_upgrades.duplicate()

	if level >= 3:
		available_upgrades += advanced_upgrades
	if level >= 4:
		available_upgrades += shotgun_upgrades + shield_upgrades + ship_roll_upgrades

	return available_upgrades[rng.randi_range(0, available_upgrades.size() - 1)]

func get_weighted_rarity() -> String:
	var total_weight = 0
	for weight in rarity_weights.values():
		total_weight += weight

	var roll = rng.randi_range(1, total_weight)
	var cumulative = 0
	for rarity in rarity_weights.keys():
		cumulative += rarity_weights[rarity]
		if roll <= cumulative:
			return rarity

	return "Common"

func _on_middle_card_select_pressed() -> void:
	print(middle_card_weapon_title.text)

func _on_left_card_select_pressed() -> void:
	print(left_card_weapon_title.text)

func _on_right_card_select_pressed() -> void:
	print(right_card_weapon_title.text)
