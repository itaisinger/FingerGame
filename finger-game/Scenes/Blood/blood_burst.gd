extends Node3D

@onready var particles: GPUParticles3D = $Blood
var particle_material: ParticleProcessMaterial

func _ready() -> void:
	particles.process_material = particles.process_material.duplicate()
	particle_material = particles.process_material
	particles.emitting = false
	splatter(global_position,Vector3.ZERO)


func splatter(position: Vector3, surface_normal: Vector3) -> void:
	global_position = position + surface_normal * 0.02
	particle_material.direction = surface_normal.normalized()
	particles.restart()
	particles.emitting = true
