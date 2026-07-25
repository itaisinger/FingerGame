extends Node3D


@export_group("Throw Settings")
@export var throw_vector: Vector3 = Vector3(0.0, 1.0, 0.0)
@export var throw_speed: float = 3.0
@export var flip_speed: float = 9.0

@export_group("Finger Hitbox")
@export var finger_hitbox: BoxShape3D = create_default_hitbox()
@export var hitbox_position: Vector3 = Vector3.ZERO
@export var hitbox_rotation: Vector3 = Vector3(0.0, 0.0, 90.0)


static func create_default_hitbox() -> BoxShape3D:
	var shape := BoxShape3D.new()

	shape.size = Vector3(0.6, 0.2, 0.2)
	shape.custom_solver_bias = 0.0
	shape.margin = 0.04

	return shape


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Button_1"):
		for i in range(1, 6):
			cut_finger(i)


func cut_finger(i: int) -> void:
	var finger_name := "finger %dR" % i
	var finger := get_node_or_null(finger_name) as Node3D
	if finger == null:
		return
	if finger.get_meta("cut", false):
		return

	if throw_vector.is_zero_approx():
		push_warning("throw_vector cannot be zero.")
		return

	if finger_hitbox == null:
		push_warning("finger_hitbox has not been assigned.")
		return

	finger.set_meta("cut", true)

	var saved_transform := finger.global_transform

	var body := RigidBody3D.new()
	body.name = "%s RigidBody" % finger_name
	body.mass = 0.2
	body.continuous_cd = true
	body.can_sleep = false

	get_tree().current_scene.add_child(body)
	body.global_transform = saved_transform

	finger.reparent(body, true)

	var collider := CollisionShape3D.new()
	collider.name = "Finger Collider"
	collider.shape = finger_hitbox.duplicate(true)
	collider.position = hitbox_position
	collider.rotation_degrees = hitbox_rotation
	body.add_child(collider)

	var throw_direction := (
		global_transform.basis * throw_vector.normalized()
	).normalized()

	var flip_axis := Vector3.UP.cross(throw_direction).normalized()

	if flip_axis.is_zero_approx():
		flip_axis = body.global_transform.basis.x.normalized()

	body.linear_velocity = throw_direction * throw_speed
	body.angular_velocity = flip_axis * flip_speed
