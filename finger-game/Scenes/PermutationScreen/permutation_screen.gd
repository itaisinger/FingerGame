extends Node3D

@export_range(0.1, 60.0, 0.1) var min_time: float = 10.0
@export_range(0.1, 60.0, 0.1) var max_time: float = 15.0
@export var SolveTime:float = 10 

@onready var label: Label = $SubViewport/Label


var binary_number: String = ""
var was_matching := false
var time_remaining: float


func _ready() -> void:
	schedule_next_activation()


func schedule_next_activation() -> void:
	time_remaining = randf_range(min_time, max_time)


func generate_binary(length: int) -> void:
	if length < 2 or length > 4:
		push_error("Length must be between 2 and 4")
		return
	binary_number = ""
	for i in range(length):
		binary_number += str(randi_range(0, 1))
	var displayed_number := "0".repeat(4 - length) + binary_number
	if displayed_number == "0000":
		generate_binary(length)
		return

	label.text = "\n " + displayed_number


func get_finger_pattern() -> String:
	var fingers := ""

	for i in range(1, 11):
		var action := "Button_%d" % i
		fingers += "1" if (
			Input.is_action_pressed(action)
			and PlayerData.FingerActive[i - 1]
		) else "0"

	return fingers


func is_permutation_shown() -> bool:
	if binary_number.is_empty():
		return false
	var fingers := get_finger_pattern()
	var pattern_length := binary_number.length()
	for start_index in range(11 - pattern_length):
		if fingers.substr(start_index, pattern_length) == binary_number:
			return true

	return false


func _process(delta: float) -> void:
	if binary_number.is_empty():
		time_remaining -= delta
		if time_remaining <= 0.0:
			generate_binary(randi_range(2, 4))
	var matching := is_permutation_shown()
	if matching and not was_matching:
		print("Success! Correct permutation: ", binary_number)
		$sfxWin.play()
		turn_off()
		schedule_next_activation()


func turn_off() -> void:
	binary_number = ""
	label.text = ""
	was_matching = false
