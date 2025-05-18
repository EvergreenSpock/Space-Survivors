extends Node3D


const SPEED = 40.0;

@onready var mesh = $BulletMesh
@onready var ray = $RayCast3D

	
func _process(delta):
	global_position += -global_transform.basis.z * SPEED * delta
	
