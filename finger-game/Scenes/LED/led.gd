extends Node3D
@export var red:Texture2D
@export var green:Texture2D

func turn_on():
	$Sprite3D.texture=green
func turn_off():
	$Sprite3D.texture=red
