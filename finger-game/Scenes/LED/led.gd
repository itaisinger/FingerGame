extends Node3D
@export var red:Texture2D
@export var green:Texture2D
var isTurnedOn=false

func turn_on():
	$Sprite3D.texture=green
func turn_off():
	if not isTurnedOn:
		print(FAILED)
	$Sprite3D.texture=red
