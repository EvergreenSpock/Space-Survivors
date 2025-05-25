extends Node3D


const SPEED = 80.0;

@onready var mesh = $BulletMesh
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

	
func _process(delta):
	global_position += -global_transform.basis.z * SPEED * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout() -> void:
	particles.emitting = true
	queue_free()
