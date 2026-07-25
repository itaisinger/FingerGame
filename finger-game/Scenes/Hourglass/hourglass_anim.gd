extends Node3D

@export var tex_offset = 0.1
@export var tex_xspd = 0.01
@export var prec = 0.0;
var dir = 1;
var upside_down = false
var rot = 0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#prec += delta * dir * 0.2 * (1 if upside_down else 1)
	var _children = [$sand,$sand_top]
	for child in _children:
		var mat = child.get_active_material(0)
		if mat:
			mat.uv1_offset.x += tex_xspd * delta
			if(mat.uv1_offset.x > 1): mat.uv1_offset.x -= 1
	# === progress === #
	
	#print(prec)
	var _y_prog = prec * 0.5
	
	if(upside_down):
		
		_y_prog = 0.5-_y_prog
		
		#bottom
		var mat = $sand_top.get_active_material(0)
		if(mat): mat.uv1_offset.y = _y_prog# + (0 if upside_down else 0.1)
		
		#top
		mat = $sand.get_active_material(0)
		if(mat): mat.uv1_offset.y = -_y_prog#  + (0.1 if upside_down else 0) #min(0.8,_y_prog + 0.1)
	else:
		#top
		var mat = $sand_top.get_active_material(0)
		if(mat): mat.uv1_offset.y = -_y_prog + (0 if upside_down else 0.1)
		
		#bottom
		mat = $sand.get_active_material(0)
		if(mat): mat.uv1_offset.y = _y_prog  + (0.1 if upside_down else 0)
		
func flip():
	rot += 180
	upside_down = !upside_down
	print("flip: " + str(upside_down))
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(rot,rotation_degrees.y,0), 1.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func update_prec(new_prec):
	prec = new_prec
