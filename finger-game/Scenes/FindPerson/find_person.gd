extends Node3D
signal cutfinger(index)
@export_dir var people := "res://images/people"
@export_dir var notPeople := "res://images/not_people"

signal FindPersonHasPerson(has_person: bool)
signal round_finished(succeeded: bool, had_person: bool, clicked: bool)
@export var round_duration := 3.0

var has_person :bool = false
var clicked_this_round := false
var time_left := 0.0
var random := RandomNumberGenerator.new()


func _ready2() -> void:
	random.randomize()
	_start_round()

var started =false
func _process(delta: float) -> void:
	if not PlayerData.GameStarted:
		return
	if not started:
		started=true
		_ready2()
	if(!PlayerData.gg):
		time_left -= delta
	if Input.is_action_just_pressed("Button_2") and PlayerData.FingerActive[1]:
		pressed()
	if time_left <= 0.0 :
		_finish_round()
		_start_round()


func pressed() -> void:
	clicked_this_round = true
	if not has_person:
		print("Pressed incorrectly!")
	else:
		print("Pressed correctly")


func _start_round() -> void:
	has_person = random.randi_range(0, 1) == 1
	select_image(has_person)
	clicked_this_round = false
	time_left = round_duration
	#print("Person: ", "YES" if has_person else "NO")

var sfx_min = 0.6
var sfx_max = 1.3

func _finish_round() -> void:
	var succeeded := has_person == clicked_this_round
	if not succeeded:
		cutfinger.emit(2)
	var player = $Sucsses if succeeded else $Fail
	var pitch = randf_range(sfx_min, sfx_max)
	player.pitch_scale = pitch
	player.play()


	#round_finished.emit(succeeded, has_person, clicked_this_round)
	#print("FIND_PERSON == SUCCESS" if succeeded else "FIND_PERSON == FAIL")


func select_image(is_person: bool) -> void:
	var folder_path: String = people if is_person else notPeople
	var image_files: Array[String] = []

	for file in ResourceLoader.list_directory(folder_path):
		var extension := file.get_extension().to_lower()

		if not file.ends_with("/") and extension in ["png", "jpg", "jpeg"]:
			image_files.append(file)

	if image_files.is_empty():
		push_error("No PNG or JPG images found in: " + folder_path)
		return

	var selected_file := image_files[random.randi_range(0, image_files.size() - 1)]
	var image_path := folder_path.path_join(selected_file)
	var selected_texture := load(image_path) as Texture2D

	if selected_texture == null:
		push_error("Failed to load image: " + image_path)
		return

	$Sprite3D.texture = selected_texture
