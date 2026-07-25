extends Node3D
func _ready() -> void:
	$HourglassLogic.connect("cutFinger",cut_finger)
	$TV_WithGame/FindPerson.connect("cutfinger",cut_finger)
	$HitTheMoleController.connect("cutfinger",cut_finger)
	$TV_WithPermutations/PermutationScreen.connect("cutfinger",cut_random_finger)
	$TVHighWithRunner/Itai_runner.connect("cutfinger",cut_finger)
	
	pass

func cut_finger(index):
	PlayerData.FingerActive[index-1]=false
	if index>5:
		$HandR.cut_finger((index-5))
	else:
		$Hand.cut_finger(6-index)

func cut_random_finger():
	var indexes: Array[int] = []
	for i in PlayerData.FingerActive.size():
		if PlayerData.FingerActive[i]:
				indexes.append(i)
	if indexes.size()<1:
		return
	var random_num := randi_range(0, indexes.size())
	cut_finger(indexes[random_num] +1)
	
	
	
