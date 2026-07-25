extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_dead = false
	for v in PlayerData.FingerActive:
		if(v): is_dead = false;
	if(is_dead):
		
		
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
