extends "res://Scripts/ship.gd"

#@export var detection_radius := 25.0
#@export var fire_cooldown := 1.5
#@export var bullet_scene: PackedScene
@export var speed := 5
@export var strafe_on_cooldown = false

@onready var player = get_node("../Player")
var can_fire := true

#func _ready() -> void:
	#var shader_mat := mesh.get_active_material(0) as ShaderMaterial
	#if shader_mat and shader_mat.has_parameter("tex"):
	#shader_mat.set_shader_parameter("tex", preload("res://Package/Enemy_Warship/Warship.png"))

func ai_get_distance():
	print(self.global_position.distance_to(player.global_position))
	return self.global_position.distance_to(player.global_position)

func ai_get_direction():
	
	var direction = player.position - self.position
	
	if ai_get_distance() < 20 and strafe_on_cooldown == false:
		
		var temp_x = 0.0
		var temp_z = 0.0
		
		if direction.x < 0:
			temp_x = direction.x - 20
		else:
			temp_x = direction.x + 20
			
		if direction.z < 0:
			temp_z = direction.z - 20
		else:
			temp_z = direction.z + 20
			
		strafe_on_cooldown = true
			
		return Vector3(temp_x,0,temp_z)
		
	elif strafe_on_cooldown == true:
		return direction
	
func ai_move():
	var direction = ai_get_direction()
	velocity = direction * speed
	move_and_slide()
	var target_basis = Basis().looking_at(direction, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, 3 * get_process_delta_time())
	
	
func _process(_delta):
	"""
	
	Ok so heres the deal, my goal is to somehow make the fighter perform a tight loop
	around a point. Originally I thought having the center point being the ship would be a good idea
	but honestly I'm not sure how to do that. You can see what I have so far (it doesnt work).
	
	If I'm able, I'm going to look into vector math and find a formula that could possibly help create
	a desired loop. If that goes well I want to put in a variety of loops some how.
	
	"""
	ai_move()
	
func _on_timer_timeout() -> void:
	strafe_on_cooldown = false
	queue_free()

#func flash_damage():
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate", Color.WHITE, 3)
