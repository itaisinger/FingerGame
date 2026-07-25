extends Node3D
func _ready() -> void:
	$HourglassLogic.connect("cutFinger",cut_finger)
	$TV_WithGame/FindPerson.connect("cutfinger",cut_finger)
	$HitTheMoleController.connect("cutfinger",cut_finger)
	pass

func cut_finger(index):
	if index>5:
		$HandR.cut_finger((index-5))
	else:
		$Hand.cut_finger(6-index)
