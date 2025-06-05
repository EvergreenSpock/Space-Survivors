extends Control

@onready var d1 = false
@onready var d2 = false
@onready var d3 = false
@onready var d4 = false
@onready var d5 = false
@onready var d6 = false
@onready var d7 = false
@onready var d8 = false
@onready var d9 = false
@onready var d10 = false
@onready var d11 = false
@onready var d12 = false
@onready var d13 = false

@onready var dialogue = $"Background/G372B-D1"




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("DatingSim ready")
	dialogue.set_dialog("[color=#DDA0DD]スペースシップわいふちゃん:[/color] Ow!! That hurts!")

#[color=#DDA0DD]Ship waifu:[/color] 
#Ow!! That hurts!
#[color=#DDA0DD]スペースシップわいふちゃん:[/color] 
 #いたっ！！それ、いたかった！！
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("test")
