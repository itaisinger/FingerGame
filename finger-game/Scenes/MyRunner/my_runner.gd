extends Node3D

const GRID_ROWS := 10
const GRID_COLUMNS := 3

var grid: Array = []
var display: Label
var player_lane := 1


func _ready() -> void:
	create_grid()
	_create_text_display()
	update_grid_display()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		move_left()
	elif Input.is_action_just_pressed("ui_right"):
		move_right()

func create_grid() -> void:
	grid.clear()

	for row_index in range(GRID_ROWS):
		var new_row: Array = []

		for column_index in range(GRID_COLUMNS):
			new_row.append("|")

		grid.append(new_row)


func update_grid_display() -> void:
	# Remove the player's previous position.
	for row in grid:
		for column_index in range(row.size()):
			if row[column_index] == "P":
				row[column_index] = "|"

	# Keep the lane between 0 and 2.
	player_lane = clampi(player_lane, 0, GRID_COLUMNS - 1)

	# Place the player on the bottom row.
	grid[GRID_ROWS - 1][player_lane] = "P"

	var text := ""

	for row in grid:
		for value in row:
			text += str(value) + " "

		text += "\n"

	display.text = text


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

	display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	display.add_theme_font_override(
		"font",
		monospace_font
	)

	display.add_theme_font_size_override(
		"font_size",
		42
	)

	add_child(display)


func move_left() -> void:
	player_lane -= 1
	update_grid_display()


func move_right() -> void:
	player_lane += 1
	if player_lane == 3:
		player_lane = 0
	update_grid_display()