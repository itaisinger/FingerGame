extends Node3D

const BUTTON_COUNT := 6
signal cutfinger(index)
@export var time_between_buttons := 4.0
@export var button_timeout := 5.0
@export var scisor1:Node3D
@export var scisor2:Node3D
@export var scisor3:Node3D
@export var scisor4:Node3D
@export var scisor5:Node3D
@export var scisor6:Node3D


var active_buttons: Array[int] = [0, 0, 0, 0, 0, 0]
var button_timers: Array[Timer] = []

var random := RandomNumberGenerator.new()
var turn_on_timer: Timer


func _ready() -> void:
	
	random.randomize()
	turn_on_timer = Timer.new()
	turn_on_timer.wait_time = time_between_buttons
	turn_on_timer.timeout.connect(_turn_on_random_button)
	add_child(turn_on_timer)
	for index in range(BUTTON_COUNT):
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = button_timeout
		timer.timeout.connect(_button_failed.bind(index))
		add_child(timer)
		button_timers.append(timer)
	_print_active_buttons()
	turn_on_timer.start()
	
func setScisorPosition():
	pass
	#for i in range(BUTTON_COUNT):
		#var button := get_node_or_null("Button" + str(i + 3)) as Node3D
		#var scisor := scisors[i]
		#if is_instance_valid(button) and is_instance_valid(scisor):
			#scisor.global_position = button.global_position+Vector3(0,0.56,0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Button_3"):
		button1()
	elif Input.is_action_just_pressed("Button_4"):
		button2()
	elif Input.is_action_just_pressed("Button_5"):
		button3()
	elif Input.is_action_just_pressed("Button_6"):
		button4()
	elif Input.is_action_just_pressed("Button_7"):
		button5()
	elif Input.is_action_just_pressed("Button_8"):
		button6()
	update_scisors()
	
func update_scisors() -> void:
	var scisors :Array[Node3D]= [
		scisor1,
		scisor2,
		scisor3,
		scisor4,
		scisor5,
		scisor6
	]
	for i in range(BUTTON_COUNT):
		var progress := 0.0
		var timer := button_timers[i]
		if active_buttons[i] == 1 and not timer.is_stopped():
			progress = 1.0 - (timer.time_left / timer.wait_time)
		progress = clampf(progress, 0.0, 1.0)
		if scisors[i].has_method("set_prec"):
			if progress!=0:
				scisors[i].call("set_prec", progress)

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed or event.echo:
		return
	var button_number: int = int(event.keycode) - int(KEY_0)
	if button_number >= 1 and button_number <= BUTTON_COUNT:
		press_button(button_number)


func press_button(button_number: int) -> void:
	var index := button_number - 1
	if active_buttons[index] == 1:
		active_buttons[index] = 0
		button_timers[index].stop()
		var led = get_node_or_null("Button" + str(index +3))
		if led != null:
			led.turn_off()
		print("success button ", button_number)
		_print_active_buttons()
	else:
		pass
		#print("did nothing button ", button_number)


func _button_failed(index: int) -> void:
	if active_buttons[index] == 0:
		return
	active_buttons[index] = 0
	var led = get_node_or_null("Button" + str(index +3 ))
	if led != null:
		led.turn_off()
	#print("failed button ", index + 3)
	cutfinger.emit(index +3)
	_print_active_buttons()


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
	turn_on_button(button_index)
	button_timers[button_index].start()

	_print_active_buttons()


func turn_on_button(index: int) -> void:
	var led = get_node_or_null("Button" + str(index+3))

	if led != null:
		led.turn_on()


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


func _print_active_buttons() -> void:
	pass
	#print(active_buttons)
