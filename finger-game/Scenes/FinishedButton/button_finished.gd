extends Node3D


func _ready() -> void:
	$button/AnimationPlayer.speed_scale = 15.0
	turn_off()


func turn_on() -> void:
	$button/AnimationPlayer.play_backwards("press")
	pass


func turn_off() -> void:
	$button/AnimationPlayer.play("press")
	pass
