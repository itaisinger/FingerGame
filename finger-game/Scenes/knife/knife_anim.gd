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
func _ready():
	if StartFinger!=null:
		global_position=StartFinger.get_node("marker").global_position
		rotation = StartFinger.rotation+Vector3(0,90,0)
	anim_player.play(anim_name)
	anim_player.pause()
	anim_length = anim_player.get_animation(anim_name).length
	dest_height = position.y;
	position.y = start_height;

func _process(delta: float) -> void:
	if(test): set_prec(my_prec)

func set_prec(prec):
	anim_player.seek(prec * anim_length, true)
	
	#move
	var _move_prog = min(max(prec*1.3,0),1)
	position.y = (start_height * (1-_move_prog)) + (dest_height * _move_prog);
	
	
