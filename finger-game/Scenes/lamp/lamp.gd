extends Node3D

var next_flicker_remain = 0.0
@export var rest_min = 3.0
@export var rest_max = 7.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_flicker_remain = randf_range(rest_min,rest_max)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	next_flicker_remain -= delta
	if(next_flicker_remain <= 0):
		flicker();
		next_flicker_remain = randf_range(rest_min,rest_max)
		

func turn_off():
	$light1.hide()
	$light2.hide()
	$light3.hide()
	
func turn_on():
	$light1.show()
	$light2.show()
	$light3.show()

func flicker():
	while(randf_range(0,1) >= 0.3):
		turn_off()
		await get_tree().create_timer(randf_range(0.01,0.2)).timeout
		turn_on()
		await get_tree().create_timer(randf_range(0.01,0.2)).timeout
