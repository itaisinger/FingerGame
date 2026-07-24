extends Node3D

@onready var anim_player = $AnimationPlayer
var anim_name = "press" # Update to match your animation name in Godot
var anim_length = 0.0
var progress = 0.0

@export var speed = 10.0 # Adjust this to change how fast it presses/releases
@export var index = "finger2"

func _ready():
	anim_player.play(anim_name)
	anim_player.pause()
	anim_length = anim_player.get_animation(anim_name).length
	progress = 0.0

func _process(delta) -> void:
	if finger_pressed():
		progress = min(progress + (speed * delta), 1.0)
	else:
		progress = max(progress - (speed * delta * 0.5), 0.0)
		
	# Multiply 0-1 progress by total length to get the correct time
	var _p = max(0,(progress - 0.5)*2)
	anim_player.seek(progress * anim_length, true)
	
func finger_pressed():
	var ret = Input.is_action_pressed(index)
	return ret
