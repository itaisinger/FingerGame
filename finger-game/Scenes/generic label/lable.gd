extends Node3D
func _ready() -> void:
	visible=true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toturial"):
		visible = not visible
