extends Node3D

@onready var anim_player = $AnimationPlayer
var anim_name = "press" # Update to match your animation name in Godot
var anim_length = 0.0
var progress = 0.0
@export var tex_offset = 1.0
@export var tresh = 0.8 
@export var speed = 10.0 # Adjust this to change how fast it presses/releases
@export var index = "finger2" #input name
@export var finger_i = 0	#actual index
var sfx_min = 0.6
var sfx_max = 1.3
func _ready():
	anim_player.play(anim_name)
	anim_player.pause()
	anim_length = anim_player.get_animation(anim_name).length
	progress = 0.0
	
	var pitch = randf_range(sfx_min, sfx_max)
	$offSfx.pitch_scale = pitch
	$onSfx.pitch_scale = pitch

func _process(delta) -> void:
	var _prev = progress
	if finger_pressed():
		progress = min(progress + (speed * delta), 1.0)
		if(_prev < tresh and progress >= tresh):
			$onSfx.play()
	else:
		progress = max(progress - (speed * delta * tresh), 0.0)
		if(_prev > tresh and progress <= tresh):
			$offSfx.play()
		
		
	# Multiply 0-1 progress by total length to get the correct time
	var _p = max(0,(progress - 0.5)*2)
	anim_player.seek(_p * anim_length, true)
	
	#texture scroll
	var mat = $out/in.get_active_material(0)
	if mat:
		mat.uv1_offset.x = tex_offset * progress
	
func finger_pressed():
	var ret = Input.is_action_pressed(index) and playerData.finger_active(finger_i);
	return ret
