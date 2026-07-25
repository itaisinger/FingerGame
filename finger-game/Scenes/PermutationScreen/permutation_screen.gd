extends Node3D

@export_range(0.1, 60.0, 0.1) var min_time: float = 10.0
@export_range(0.1, 60.0, 0.1) var max_time: float = 15.0
@export var SolveTime:float = 10 
var SolveTimeRemain  = SolveTime;
@onready var label: Label = $SubViewport/Label
@onready var timerlabel: Label = $SubViewport/timerLabel
signal cutfinger()

var binary_number: String = ""
var was_matching := false
var rest_time_remain: float

func get_timer_text():
	var str ="\n\n\n\n\nO"
	for i in range(floor(SolveTimeRemain)):
		str += "_"
	str += "x"
	#print("text: ",SolveTimeRemain," ",str)
	return str

func _ready() -> void:
	schedule_next_activation()

func schedule_next_activation() -> void:
	rest_time_remain = randf_range(min_time, max_time)

func generate_binary(length: int) -> void:
	if length < 2 or length > 4:
		push_error("Length must be between 2 and 4")
		return
	SolveTimeRemain = SolveTime;
	binary_number = ""
	for i in range(length):
		binary_number += str(randi_range(0, 1))
	var displayed_number := "0".repeat(4 - length) + binary_number
	if displayed_number == "0000":
		generate_binary(length)
		return
	label.text =  "\n "+ displayed_number

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

#func _process(delta: float) -> void:
	#if binary_number.is_empty():
		#rest_time_remain -= delta
		#if rest_time_remain <= 0.0:
			#generate_binary(randi_range(2, 4))
	#var matching := is_permutation_shown()
	#if matching and not was_matching:
		#$sfxWin.play()
		#turn_off()
		#schedule_next_activation()
	#timerlabel.text = get_timer_text()
	##label.text = "\n  "+binary_number
	#SolveTimeRemain = max(0.0, SolveTimeRemain-delta);
	#if(SolveTimeRemain <= 0 and !binary_number.is_empty()):
		#cutfinger.emit()
		#binary_number = ""
		#schedule_next_activation()

func _process(delta: float) -> void:
	
	if(PlayerData.gg):
		label.text = ""
		timerlabel.text = ""
	
	if binary_number.is_empty():
		rest_time_remain -= delta

		if rest_time_remain <= 0.0:
			generate_binary(randi_range(2, 4))

		return

	SolveTimeRemain = max(0.0, SolveTimeRemain - delta)
	timerlabel.text = get_timer_text()

	var matching := is_permutation_shown()

	if matching:
		$sfxWin.play()
		turn_off()
		schedule_next_activation()
		return

	if SolveTimeRemain <= 0.0:
		cutfinger.emit()
		turn_off()
		schedule_next_activation()

func turn_off() -> void:
	binary_number = ""
	label.text = ""
	timerlabel.text = ""
	was_matching = false
