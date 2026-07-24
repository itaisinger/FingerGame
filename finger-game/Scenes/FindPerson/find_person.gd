extends Node3D

signal person_changed(has_person: bool)
signal round_finished(succeeded: bool, had_person: bool, clicked: bool)

@export var round_duration := 3.0

var has_person := false
var clicked_this_round := false
var round_is_finished := false
var time_left := 0.0
var random := RandomNumberGenerator.new()


func _ready() -> void:
	random.randomize()
	_start_round()


func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0:
		if not round_is_finished:
			_finish_round()
		_start_round()


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
		and not round_is_finished
	):
		clicked_this_round = true
		_finish_round()


func _start_round() -> void:
	has_person = random.randi_range(0, 1) == 1
	clicked_this_round = false
	round_is_finished = false
	time_left = round_duration
	person_changed.emit(has_person)
	print("Person: ", "YES" if has_person else "NO")


func _finish_round() -> void:
	round_is_finished = true
	var succeeded := has_person == clicked_this_round
	round_finished.emit(succeeded, has_person, clicked_this_round)
	print("SUCCESS" if succeeded else "FAIL")
