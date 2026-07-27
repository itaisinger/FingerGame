extends Node3D

@onready var anim_player = $AnimationPlayer
#@onready var trans = $Transform
var anim_name = "Cut" # Update to match your animation name in Godot
var anim_length = 0.0
var active = true
var dest_height = 0;
@export var start_height = 0;
@export var my_prec = 0.0;
@export var test = false;
var trans
@export var StartFinger:Node3D
var is_retract = false
var progress = 0;
var _delta = 0;

#rotation
var rot_dest = 0.0
var rot_start = 0.0

func _ready():
	anim_player.play(anim_name)
	anim_player.pause()
	anim_length = anim_player.get_animation(anim_name).length
	dest_height = position.y;
	position.y = start_height;
	rot_start = randf_range(-360,360);
	rot_dest = rotation_degrees.y;
	rotation_degrees.y = rot_start;

func _process(delta: float) -> void:
	_delta = delta
	
	#roll
	var _rot_prog = max(0,progress*1.6 - 0.6);
	anim_player.seek(_rot_prog * anim_length, true)
	
	#move
	var _move_prog = min(max(progress*1.45,0),1)
	position.y = (start_height * (1-_move_prog)) + (dest_height * _move_prog);
	_move_prog = min(1,_move_prog+0.15)
	rotation_degrees.y = (rot_start * (1-_move_prog)) + (rot_dest * _move_prog);
	
func set_prec(prec):
	progress = max(progress-_delta*0.4,prec);
			
