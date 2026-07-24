extends Node3D

const BUTTON_COUNT := 6
@export var time_between_buttons := 4.0
var active_buttons: Array[int] = [0, 0, 0, 0, 0, 0]
var random := RandomNumberGenerator.new()
var turn_on_timer: Timer



func _ready() -> void:
	random.randomize()
	turn_on_timer = Timer.new()
	turn_on_timer.wait_time = time_between_buttons
	turn_on_timer.timeout.connect(_turn_on_random_button)
	add_child(turn_on_timer)
	_print_active_buttons()
	turn_on_timer.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MoleButton_1"):
		button1()
	elif Input.is_action_just_pressed("MoleButton_2"):
		button2()
	elif Input.is_action_just_pressed("MoleButton_3"):
		button3()
	elif Input.is_action_just_pressed("MoleButton_4"):
		button4()
	elif Input.is_action_just_pressed("MoleButton_5"):
		button5()
	elif Input.is_action_just_pressed("MoleButton_6"):
		button6()

func _unhandled_key_input(event: InputEvent) -> void:
	var button_number: int = int(event.keycode) - int(KEY_0)
	if button_number >= 1 and button_number <= BUTTON_COUNT:
		press_button(button_number)


func press_button(button_number: int) -> void:
	var index := button_number - 1
	if active_buttons[index] == 1:
		active_buttons[index] = 0
		print("success button ", button_number)
		_print_active_buttons()
	else:
		print("failed button ", button_number)


func button1() -> void:
	press_button(1)
func button2() -> void:
	press_button(2)
func button3() -> void:
	press_button(3)
func button4() -> void:
	press_button(4)
func button5() -> void:
	press_button(5)
func button6() -> void:
	press_button(6)


func _turn_on_random_button() -> void:
	var turned_off_buttons: Array[int] = []
	for button_index in range(BUTTON_COUNT):
		if active_buttons[button_index] == 0:
			turned_off_buttons.append(button_index)
	if turned_off_buttons.is_empty():
		return
	var position := random.randi_range(0, turned_off_buttons.size() - 1)
	var button_index := turned_off_buttons[position]
	active_buttons[button_index] = 1
	_print_active_buttons()


func _print_active_buttons() -> void:
	print(active_buttons)
