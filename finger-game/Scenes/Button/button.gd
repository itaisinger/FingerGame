extends Node3D

const RED: Color = Color(0.561, 0.0, 0.0, 1.0)
const GREEN: Color = Color(0.0, 0.422, 0.0, 1.0)

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var material: StandardMaterial3D


func _ready() -> void:
	var original := mesh_instance.get_active_material(0) as StandardMaterial3D

	if original:
		material = original.duplicate() as StandardMaterial3D
	else:
		material = StandardMaterial3D.new()

	material.albedo_texture = null
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.material_override = material

	turn_off()


func turn_on() -> void:
	material.albedo_color = GREEN


func turn_off() -> void:
	material.albedo_color = RED
