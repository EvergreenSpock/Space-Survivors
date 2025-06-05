extends Control

# UI node references for card slots and labels
@onready var left_card = $LeftCard
@onready var middle_card = $MiddleCard
@onready var right_card = $RightCard

@onready var left_card_weapon_title = $LeftCard/WeaponTitle
@onready var middle_card_weapon_title = $MiddleCard/WeaponTitle
@onready var right_card_weapon_title = $RightCard/WeaponTitle

@onready var left_card_weapon_desc = $LeftCard/WeaponDescription
@onready var middle_card_weapon_desc = $MiddleCard/WeaponDescription
@onready var right_card_weapon_desc = $RightCard/WeaponDescription
@onready var reward_screen = get_tree().get_root().get_node_or_null("Main Scene/Player/PlayerCamera/RewardScreen")

# Random number generator for upgrade selection
var rng = RandomNumberGenerator.new()

# Rarity appearance and effects
var rarities = {
	"Common": Color("ffffff"),
	"Uncommon": Color("55ff55"),
	"Rare": Color("5599ff"),
	"Legendary": Color("ffcc00")
}

# Upgrade effect multipliers by rarity
var rarity_value_multipliers = {
	"Common": 1.0,
	"Uncommon": 1.5,
	"Rare": 2.0,
	"Legendary": 3.0
}

# Weighted rarity chances
var rarity_weights = {
	"Common": 60,
	"Uncommon": 25,
	"Rare": 12,
	"Legendary": 3
}

# Upgrade pools by category
var early_upgrades = [
	{"name": "Health Upgrade", "desc": "+25 Max Health", "id": "max_health_upgrade", "value": 25},
	{"name": "Fuel Capacity", "desc": "+20 Max Fuel", "id": "max_fuel_upgrade", "value": 20},
	{"name": "Basic Weapon Damage", "desc": "+10% Bullet Damage", "id": "start_gun_damage_percentage_upgrade", "value": 0.10}
]

var advanced_upgrades = [
	{"name": " シールドをアンロック", "desc": "Grants regenerating shields", "id": "shield_upgrade_bool"},
	{"name": " さんだんじゅうをアンロック", "desc": "Unlocks a powerful short-range weapon", "id": "shotgun_upgrade_bool"},
	{"name": " シップのみかわしアップ–をアンロック", "desc": "Gain evasive roll movement", "id": "evasive_upgrade_bool"}
]

var shotgun_upgrades = [
	{"name": "Shotgun Fire-Rate", "desc": "Increases shotgun fire rate", "id": "shotgun_fire_rate_upgrade", "value": 0.15},
	{"name": "Shotgun Damage", "desc": "+20% Shotgun Damage", "id": "shotgun_damage_percentage_upgrade", "value": 0.2},
	{"name": "Shotgun Bullet Speed", "desc": "Faster shotgun bullets", "id": "shotgun_bullet_speed_upgrade", "value": 1}
]

var ship_roll_upgrades = [
	{"name": "Roll Cooldown Reduction", "desc": "Roll more frequently", "id": "roll_cooldown_reduction", "value": 0.2},
	{"name": "Roll Burst Effect", "desc": "Explosion after roll", "id": "explosive_roll_burst_bool_upgrade"}
]

var shield_upgrades = [
	{"name": "Shield Strength", "desc": "+25% Shield Capacity", "id": "max_shield_percentage_upgrade", "value": 0.25},
	{"name": "Shield Recharge Rate", "desc": "Faster shield recharge", "id": "faster_shield_regen_cooldown_upgrade", "value": 1}
]

# Internal tracking for card content and chosen upgrades
var card_slots = []
var selected_upgrades = []

# Initialize the card slots after one frame
func _ready() -> void:
	rng.randomize()
	await get_tree().process_frame
	card_slots = [
		{"title": left_card_weapon_title, "desc": left_card_weapon_desc, "node": left_card},
		{"title": middle_card_weapon_title, "desc": middle_card_weapon_desc, "node": middle_card},
		{"title": right_card_weapon_title, "desc": right_card_weapon_desc, "node": right_card}
	]

# When reward screen is shown, populate options
func _on_reward_screen_visibility_changed() -> void:
	_populate_cards()

# Core logic to populate 3 upgrade cards
func _populate_cards():
	if card_slots.size() < 3:
		#push_error("Card slots not initialized yet!")
		return

	selected_upgrades.clear()

	for i in range(3):
		var base_upgrade = get_random_upgrade(Global.player_level)
		var rarity_key = get_weighted_rarity()
		var rarity_color = rarities[rarity_key]
		var multiplier = rarity_value_multipliers.get(rarity_key, 1.0)

		var upgrade = base_upgrade.duplicate()
		upgrade["rarity"] = rarity_key

		if upgrade.has("value"):
			var scaled_value
			if typeof(upgrade["value"]) == TYPE_INT:
				scaled_value = int(upgrade["value"] * multiplier)
			else:
				scaled_value = float(upgrade["value"] * multiplier)
			upgrade["value"] = scaled_value

			if upgrade["id"] == "start_gun_damage_percentage_upgrade" or upgrade["id"] == "shotgun_damage_percentage_upgrade":
				upgrade["desc"] = "+%s%% %s" % [int(scaled_value * 100), upgrade["name"]]
			elif upgrade["id"] in ["max_health_upgrade", "max_fuel_upgrade"]:
				upgrade["desc"] = "+%s %s" % [scaled_value, upgrade["name"]]
			else:
				upgrade["desc"] = "%s" % upgrade["desc"]
		else:
			upgrade["desc"] = "%s" % upgrade["desc"]

		card_slots[i]["title"].text = "%s: %s" % [rarity_key, upgrade["name"]]
		card_slots[i]["desc"].text = upgrade["desc"]
		card_slots[i]["node"].modulate = rarity_color

		selected_upgrades.append(upgrade)

# Apply selected upgrade to player state
func apply_upgrade(index: int):
	if index < 0 or index >= selected_upgrades.size():
		return

	var upgrade = selected_upgrades[index]
	if upgrade.has("value"):
		Global.set(upgrade["id"], Global.get(upgrade["id"]) + upgrade["value"])
		print(Global.get(upgrade["id"]))
	else:
		Global.set(upgrade["id"], true)

# Select a random upgrade from the pool based on player level
func get_random_upgrade(level: int) -> Dictionary:
	var available_upgrades = early_upgrades.duplicate()
	if level >= 3:
		available_upgrades += advanced_upgrades
	if level >= 4:
		available_upgrades += shotgun_upgrades + shield_upgrades + ship_roll_upgrades
	return available_upgrades[rng.randi_range(0, available_upgrades.size() - 1)]

# Choose a rarity using weights
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

# Card selection handlers - apply only the selected upgrade
func _on_middle_card_select_pressed() -> void:
	apply_upgrade(1)
	get_tree().paused = false
	reward_screen.hide()

func _on_left_card_select_pressed() -> void:
	apply_upgrade(0)
	get_tree().paused = false
	reward_screen.hide()

func _on_right_card_select_pressed() -> void:
	apply_upgrade(2)
	get_tree().paused = false
	reward_screen.hide()
