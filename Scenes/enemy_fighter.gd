extends "res://Scripts/ship.gd"

#@export var detection_radius := 25.0
#@export var fire_cooldown := 1.5
#@export var bullet_scene: PackedScene
@export var speed := 5

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
	
	if ai_get_distance() < 20:
		
		var temp_x = 0.0
		var temp_z = 0.0
		
		if direction.x < 0:
			temp_x = direction.x - 40
		else:
			temp_x = direction.x + 40
			
		if direction.z < 0:
			temp_z = direction.z - 40
		else:
			temp_z = direction.z + 40
			
		return Vector3(temp_x,0,temp_z)
		
	else:
		return direction
	
func ai_move():
	var direction = ai_get_direction()
	velocity = direction * speed
	move_and_slide()
	var target_basis = Basis().looking_at(direction, Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, 3 * get_process_delta_time())
	
	
func _process(_delta):
	
	ai_move()
	
	#var distance = ai_get_distance()
	
	#if distance < 35:
		
		#var direction = ai_get_direction()
		#velocity = direction.normalized() * speed
		
		
		
		#var target_basis = Basis().looking_at(ai_get_direction().normalized(), Vector3.UP)
		#global_transform.basis = global_transform.basis.slerp(target_basis, 3 * get_process_delta_time())
		
	#else:
		
		#ai_move()
	

#func flash_damage():
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate", Color.WHITE, 3)
