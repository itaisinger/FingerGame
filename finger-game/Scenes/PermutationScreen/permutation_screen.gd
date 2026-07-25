extends Node3D

@onready var label: Label = $SubViewport/Label

var binary_number: String = ""
var was_matching := false

func _ready() -> void:
	generate_binary(3)

func generate_binary(t: int) -> void:
	if t < 2 or t > 4:
		push_error("t must be between 2 and 4")
		return
	binary_number = ""
	for i in range(t):
		binary_number += str(randi_range(0, 1))
	label.text = "\n " + "0".repeat(4 - t) + binary_number


func get_finger_pattern() -> String:
	var fingers := ""
	for i in range(1, 11):
		var action := "Button_%d" % i
		fingers += "1" if Input.is_action_pressed(action) else "0"
	return fingers


func is_permutation_shown() -> bool:
	if binary_number.is_empty():
		return false
	var fingers := get_finger_pattern()
	var pattern_length := binary_number.length()
	for start_index in range(11 - pattern_length):
		var finger_group := fingers.substr(start_index, pattern_length)
		if finger_group == binary_number:
			return true
	return false


func _process(_delta: float) -> void:
	var matching := is_permutation_shown()
	if matching and not was_matching:
		print("Correct permutation: ", binary_number)
		generate_binary(4)
		$sfxWin.play()
		#turn_off()
	was_matching = matching

func turn_off():
	$SubViewport/Label.text=""
