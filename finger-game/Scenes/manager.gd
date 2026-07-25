extends Node3D

var done = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var finger_count = 0
	for v in PlayerData.FingerActive:
		if(v): finger_count += 1;
	print("-- finger count: ",finger_count)
	if(finger_count == 0 and !done):
		print("game over")
		done = true
		PlayerData.gg = true;
		await get_tree().create_timer(6.0).timeout
		for i in range((PlayerData.FingerActive.size())):
			PlayerData.FingerActive[i]=true
		get_tree().reload_current_scene()
