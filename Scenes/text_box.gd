extends RichTextLabel

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

@onready var ready_to_move = false

const CHARACTER_SPEED: float = .17



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("interact") && !ready_to_move:
		ready_to_move = true
	
	#d1
	if !d1:
		await get_tree().create_timer(.3).timeout
		set_dialog("[color=#DDA0DD]Ship waifu:[/color]Ow!! That hurts! [p] [color=#DDA0DD]スペースシップワイフちゃん:[/color] いたっ！！それ、いたかった！！")
		d1 = true
	#d2
	if d1 and !d2 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color] ?????[p][color=#FFC0CB]シップ:[/color] ？？？？？")
		print("test")
		await get_tree().create_timer(.25).timeout
		d2 = true
	#d3
	if d2 and !d3 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color] You can talk???[p][color=#FFC0CB]シップ:[/color] 話せる？？？")
		await get_tree().create_timer(.25).timeout
		d3 = true
	#d4
	if d3 and !d4 and ready_to_move:
		set_dialog("[color=#DDA0DD]Ship waifu:[/color] Rude! Of course I can talk, idiot.[p][color=#DDA0DD]スペースシップワイフちゃん:[/color] しつれいなぁ、もちろんだよ、このばか")
		await get_tree().create_timer(.25).timeout
		d4 = true
	#d5
	if d4 and !d5 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color] Sorry, I was just surprised. What’s your name?[p][color=#FFC0CB]シップ:[/color] あ、すみません。わたしは おどろきました。おなまえは？")
		await get_tree().create_timer(.25).timeout
		d5 = true
	#d6
	if d5 and !d6 and ready_to_move:
		set_dialog("[color=#DDA0DD]G732B Defender of the Aldani System, 7th generation naval Covalent Frigate of the 1st class LB97A21F5291ZRFN70DQ994A line model and protector of the innocent:[/color] G732B! 3500 years of service! Honored by the Queen majesty herself! Defender of the Aldani System! 7th generation naval Covalent Frigate of the 1st class LB97A21F5291ZRFN70DQ994A line model and protector of the innocent![p][color=#DDA0DD]G732B:[/color]「G732B」防衛者のアウダニ星系・七世代海軍のコヴァレント・フリゲート第１級LB97A21F5291ZRFN70DQ994A型")
		await get_tree().create_timer(.25).timeout
		d6 = true
	#d7
	if d6 and !d7 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color] Okay… what do you need from me?[p][color=#FFC0CB]シップ:[/color] ああ。。。じゃあ。。。あの、なにかごようですか？")
		await get_tree().create_timer(.25).timeout
		d7 = true
	#d8
	if d7 and !d8 and ready_to_move:
		set_dialog("[color=#DDA0DD]G732B:[/color] … I need repairs… [i][b]turns shyly[/b][/i][p][color=#DDA0DD]G732B:[/color] 。。。しゅうりをしてはいけないんです。。。")
		await get_tree().create_timer(.25).timeout
		d8 = true
	#d9
	if d8 and !d9 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color]  oh sure, we can definitely help with that. Permission to dock?[p][color=#FFC0CB]シップ:[/color]  ドックをいってもよろしいですか")
		await get_tree().create_timer(.25).timeout
		d9 = true
	#d10
	if d9 and !d10 and ready_to_move:
		set_dialog("[color=#DDA0DD]G732B:[/color] [i] blushes [/i] permission granted.[p][color=#DDA0DD]G732B:[/color]  よろしい……です…///////")
		await get_tree().create_timer(.25).timeout
		d10 = true
	#d11
	if d10 and !d11 and ready_to_move:
		set_dialog("[color=#ECF87F]Narrator:[/color] A full day passes with the crews focused on repairs. Once the ships are able to communicate again, both exhausted crews settle in for a well-deserved night’s rest.[p] [color=#ECF87F]かたりて:[/color] しゅうりをしているあいだに、うちゅうせんたちはかいわできるひまがありませんでした。しゅうりはかんりょうされたあとに、クルーはやすみました。それからうちゅうせんはまたはなせるようになりました。")
		await get_tree().create_timer(.25).timeout
		d11 = true
	#d12
	if d11 and !d12 and ready_to_move:
		set_dialog("[color=#DDA0DD]G732B:[/color]  …Goodnight Ship-chan[p][color=#DDA0DD]G732B:[/color]  。。。おやすみなさいシップちゃん")
		await get_tree().create_timer(.25).timeout
		d12 = true
	#d13
	if d12 and !d13 and ready_to_move:
		set_dialog("[color=#FFC0CB]Ship:[/color] Oh ummm, goodnight G732B-chan![p][color=#FFC0CB]シップ:[/color] あ、あの、おやすみなさいG732Bちゃん")
		await get_tree().create_timer(.25).timeout
		d13 = true
	
func set_dialog(string: String):
	ready_to_move = false
	visible_characters = 0
	text = string
	for i in range(string.length()):
		visible_characters += 1
		await get_tree().create_timer(CHARACTER_SPEED).timeout
	await get_tree().create_timer(.25).timeout
