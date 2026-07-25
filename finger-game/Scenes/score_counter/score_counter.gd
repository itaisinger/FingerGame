extends Node3D

@export var start_val = 0
@export var rolf_range = 15

var current_remain = 0.0
var count = 0;
var spd = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = start_val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_remain -= delta*spd
	if(current_remain <= 0):
		#progress
		current_remain += 1
		count -= 1
		print("tick")
		var vol = randf_range(0.7,1.3) 
		#jokes
		var pitch = randf_range(0.7,1.3) 
		if(randi_range(0,rolf_range) == 2): count += 2
		if(randi_range(0,rolf_range) == 2): current_remain *= randf_range(0.3,0.6) 
		if(randi_range(0,rolf_range) == 2): current_remain *= randf_range(2,3) 
		if(randi_range(0,rolf_range) == 2): vol *= 1.5
		if(randi_range(0,rolf_range) == 2): pitch *= 1.5 
		
		#sfx
		$tickSfx.play();
		
func done():
	print("win")
	
func disable():
	spd = 0
		
