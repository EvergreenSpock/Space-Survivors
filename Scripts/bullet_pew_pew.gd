extends Node3D


const SPEED = 80.0;

@export var damage: int = 25 #Medium damage bullet

@onready var mesh = $BulletMesh
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D


signal hit_something(target: Node, damage: int)

func _process(delta):
	var collider = ray.get_collider()
	global_position += -global_transform.basis.z * SPEED * delta
	if collider and collider.has_method("apply_damage"):
		emit_signal("hit_something", collider, damage)
		collider.apply_damage(damage)
		particles.emitting = true
		mesh.visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()


func _on_timer_timeout() -> void:
	particles.emitting = true
	queue_free()
