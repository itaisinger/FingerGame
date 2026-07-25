extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D

var rain_enabled := false
var cycle_id := 0


func _ready() -> void:
	particles.emitting = false


func set_rain_enabled(value: bool) -> void:
	if rain_enabled == value:
		return

	rain_enabled = value
	cycle_id += 1
	particles.emitting = false

	if rain_enabled:
		_rain_loop(cycle_id)


func _rain_loop(id: int) -> void:
	while rain_enabled and id == cycle_id:
		# Wait randomly between 1 and 3 seconds.
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

		if not rain_enabled or id != cycle_id:
			return

		# Emit for one second.
		particles.emitting = true
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

		if id != cycle_id:
			return

		particles.emitting = false
