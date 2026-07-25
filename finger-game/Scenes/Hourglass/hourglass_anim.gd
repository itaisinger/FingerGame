extends Node3D

@export var tex_offset = 0.1
@export var tex_xspd = 0.01
@export var prec = 0.0;
var dir = 1;
@export var upside_down = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prec += delta * dir * 0.2 * (1 if upside_down else 1)
	#if(prec >= 1.0 or prec <= 0.0): flip();
	#roll
	var _children = [$sand,$sand_top]
	for child in _children:
		var mat = child.get_active_material(0)
		if mat:
			mat.uv1_offset.x += tex_xspd * delta
			if(mat.uv1_offset.x > 1): mat.uv1_offset.x -= 1
	
	# === progress === #
	
	#print(prec)
	var _y_prog = prec * 0.5	
	
	var top = $sand_top
	var bottom = $sand
	if(false and upside_down):
		top = $sand
		bottom = $sand_top
		
	#top
	var mat = top.get_active_material(0)
	if(mat): mat.uv1_offset.y = _y_prog + (0 if upside_down else 0.1)
	
	#bottom
	mat = bottom.get_active_material(0)
	if(mat): mat.uv1_offset.y = -_y_prog + (0.1 if upside_down else 0) #min(0.8,_y_prog + 0.1)

func flip():
	upside_down = !upside_down
	print("flip")
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", Vector3(rotation_degrees.x + 180,0,0), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func update_prec(new_prec):
	prec = new_prec
