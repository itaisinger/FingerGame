extends Node3D

const TRACK_LENGTH := 8
const LANE_COUNT := 3
const STEP_TIME := 0.75

const MIN_WAVE_LENGTH := 2
const MAX_WAVE_LENGTH := 4
const MIN_WAVE_GAP := 2
const MAX_WAVE_GAP := 3

const TRAIN_SYMBOL := "T"
const BOMB_SYMBOL := "*"

var player_lane := 1
var score := 0

var steps_until_wave := 2
var wave_steps_remaining := 0
var wave_safe_lane := 1

var obstacles: Array[Dictionary] = []

var game_over := false
var step_timer: Timer
var display: Label


func _ready() -> void:
	randomize()
	_create_text_display()
	_create_step_timer()
	_update_display()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return

	if not event.pressed:
		return

	if game_over:
		if (
			event.button_index == MOUSE_BUTTON_LEFT
			or event.button_index == MOUSE_BUTTON_RIGHT
		):
			_restart()
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		player_lane = wrapi(
			player_lane - 1,
			0,
			LANE_COUNT
		)
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		player_lane = wrapi(
			player_lane + 1,
			0,
			LANE_COUNT
		)
	else:
		return

	if _player_hits_obstacle():
		_end_game()
		return

	_update_display()


func _create_text_display() -> void:
	display = Label.new()

	var monospace_font := SystemFont.new()
	monospace_font.font_names = PackedStringArray([
		"Consolas",
		"Courier New",
		"monospace"
	])

	display.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	display.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	display.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	display.add_theme_font_override(
		"font",
		monospace_font
	)

	display.add_theme_font_size_override(
		"font_size",
		42
	)

	add_child(display)


func _create_step_timer() -> void:
	step_timer = Timer.new()
	step_timer.wait_time = STEP_TIME
	step_timer.timeout.connect(_take_step)

	add_child(step_timer)
	step_timer.start()


func _take_step() -> void:
	# Move obstacles toward the player.
	for obstacle in obstacles:
		obstacle.row += 1

	if _player_hits_obstacle():
		_end_game()
		return

	# Remove obstacles that passed the player.
	for index in range(
		obstacles.size() - 1,
		-1,
		-1
	):
		if int(obstacles[index].row) >= TRACK_LENGTH:
			obstacles.remove_at(index)

	score += 1

	if wave_steps_remaining > 0:
		_spawn_obstacle_row()
		wave_steps_remaining -= 1

		if wave_steps_remaining == 0:
			steps_until_wave = randi_range(
				MIN_WAVE_GAP,
				MAX_WAVE_GAP
			)
	else:
		steps_until_wave -= 1

		if steps_until_wave <= 0:
			wave_steps_remaining = randi_range(
				MIN_WAVE_LENGTH,
				MAX_WAVE_LENGTH
			)

			wave_safe_lane = randi_range(
				0,
				LANE_COUNT - 1
			)

			_spawn_obstacle_row()
			wave_steps_remaining -= 1

	_update_display()


func _spawn_obstacle_row() -> void:
	var safe_lane := wave_safe_lane

	var blocked_lane_count := (
		2 if randf() < 0.65 else 1
	)

	var blocked_lanes: Array[int] = []

	for lane in range(LANE_COUNT):
		if lane == safe_lane:
			continue

		if not _can_place_obstacle(lane):
			continue

		blocked_lanes.append(lane)

	blocked_lanes.shuffle()

	var amount := mini(
		blocked_lane_count,
		blocked_lanes.size()
	)

	for index in range(amount):
		var obstacle_lane := blocked_lanes[index]
		var symbol := TRAIN_SYMBOL

		var can_be_bomb := (
			absi(obstacle_lane - safe_lane) > 1
		)

		if can_be_bomb and randf() < 0.5:
			symbol = BOMB_SYMBOL

		obstacles.append({
			"lane": obstacle_lane,
			"row": 0,
			"symbol": symbol
		})


func _can_place_obstacle(lane: int) -> bool:
	var obstacle_one_row_back := false
	var obstacle_two_rows_back := false

	for obstacle in obstacles:
		if int(obstacle.lane) != lane:
			continue

		var obstacle_row := int(obstacle.row)

		if obstacle_row == 1:
			obstacle_one_row_back = true
		elif obstacle_row == 2:
			obstacle_two_rows_back = true

	# Consecutive obstacles are allowed.
	#
	# T
	# T
	# T
	if obstacle_one_row_back:
		return true

	# A gap of exactly one empty cell is forbidden.
	#
	# T
	# empty
	# T
	if obstacle_two_rows_back:
		return false

	# There are at least two empty cells.
	return true


func _obstacle_hits_lane(
	obstacle: Dictionary,
	lane: int
) -> bool:
	var obstacle_lane := int(obstacle.lane)

	if obstacle.symbol == BOMB_SYMBOL:
		return absi(obstacle_lane - lane) <= 1

	return obstacle_lane == lane


func _player_hits_obstacle() -> bool:
	for obstacle in obstacles:
		if int(obstacle.row) != TRACK_LENGTH - 1:
			continue

		if _obstacle_hits_lane(
			obstacle,
			player_lane
		):
			return true

	return false


func _end_game() -> void:
	game_over = true
	step_timer.stop()
	_update_display()


func _restart() -> void:
	player_lane = 1
	score = 0

	steps_until_wave = 2
	wave_steps_remaining = 0
	wave_safe_lane = 1

	obstacles.clear()

	game_over = false
	step_timer.start()

	_update_display()


func _update_display() -> void:
	var lines: PackedStringArray = []

	lines.append("THREE LANE RUNNER")
	lines.append(
		"Left click = move left   Right click = move right"
	)
	lines.append(
		"* bombs also hit the lanes beside them"
	)
	lines.append("Score: %d" % score)
	lines.append("")

	for row in range(TRACK_LENGTH):
		var lanes: Array[String] = []
		lanes.resize(LANE_COUNT)
		lanes.fill(" ")

		for obstacle in obstacles:
			if int(obstacle.row) == row:
				lanes[int(obstacle.lane)] = (
					str(obstacle.symbol)
				)

		if row == TRACK_LENGTH - 1:
			lanes[player_lane] = "P"

		lines.append(
			"|%s|%s|%s|" % lanes
		)

	if game_over:
		lines.append("")
		lines.append("BOOM! GAME OVER")
		lines.append("Click to restart")

	display.text = "\n".join(lines)
