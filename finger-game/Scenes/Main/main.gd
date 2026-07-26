extends Node3D
func _ready() -> void:
	$HourglassLogic.connect("cutFinger",cut_finger)
	$TV_WithGame/FindPerson.connect("cutfinger",cut_finger)
	$HitTheMoleController.connect("cutfinger",cut_finger)
	$TV_WithPermutations/PermutationScreen.connect("cutfinger",cut_random_finger)
	$TVHighWithRunner/Itai_runner.connect("cutfinger",cut_finger)
	
	pass
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Toturial"):
		PlayerData.GameStarted=true
	if Input.is_action_just_pressed("Practice"):
		practice_mode()
		# PlayerData.Practice=true
		# PlayerData.GameStarted=true
	
func cut_finger(index):
	if PlayerData.Practice:
		return
	PlayerData.FingerActive[index-1]=false
	if index>5:
		$HandR.cut_finger((index-5))
	else:
		$Hand.cut_finger(6-index)

func cut_random_finger():
	if PlayerData.Practice:
		return
	var indexes: Array[int] = []
	for i in PlayerData.FingerActive.size():
		if PlayerData.FingerActive[i]:
				indexes.append(i)
	if indexes.size()<1:
		return
	var random_num := randi_range(1, indexes.size())
	cut_finger(indexes[random_num-1] +1)
	
func practice_mode():
	PlayerData.Practice=true
	PlayerData.GameStarted=true
	var labels := find_children("Lable*", "", true, false)
	for label in labels:
		label.visible=false
		print(label.name)
	
	
