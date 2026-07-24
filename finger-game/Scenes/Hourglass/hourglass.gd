extends Node3D

const TRANSFER_RATE := 20.0

class HourglassPart:
	var time: float

	func _init(starting_time: float) -> void:
		time = starting_time


var part_1 := HourglassPart.new(100.0)
var part_2 := HourglassPart.new(0.0)
var part_1_is_up := true
var print_timer := 0.0


func _process(delta: float) -> void:
	var upper := part_1 if part_1_is_up else part_2
	var lower := part_2 if part_1_is_up else part_1
	var transferred_time: float = min(delta * TRANSFER_RATE, upper.time)

	upper.time -= transferred_time
	lower.time += transferred_time

	print_timer += delta
	if print_timer >= 0.5:
		print_timer -= 0.5
		print("Part 1: ", part_1.time, " | Part 2: ", part_2.time, " | Up: ", 1 if part_1_is_up else 2)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		part_1_is_up = not part_1_is_up
