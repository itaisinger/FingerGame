extends Node3D
var GRID_ROWS = 13
var pos = 0
var rows_since_last_obstacle = 0
var grid = []
var timer := 0.0
var roll = 0
var ret
var hp=2
var GameOverOn=0
var display: Label
signal cutfinger(index)
@export var player_char: String = "P"
@export var obstacle_char: String = "X"
@export var empty_char: String = "."
@export var damaged_char: String="X"
func _ready2() -> void:
	for i in range(GRID_ROWS):
		grid.append([0, 0, 0])

var started=false
func _process(delta: float) -> void:
	if not PlayerData.GameStarted:
		return
	if not started:
		started=true
		_ready2()
	if Input.is_action_just_pressed("Button_9")and PlayerData.FingerActive[8]:
		press2()
	elif Input.is_action_just_pressed("Button_10")and PlayerData.FingerActive[9]:
		press1()
	timer += delta
	if timer >= 1.0:
		timer -= 1.0
		if hp>0:
			update()
		else:
			deathScreen()

func deathScreen():
	if GameOverOn == 1:
		$SubViewport/Label.text=""
		GameOverOn=0
		return
	GameOverOn = 1
	var lines: Array[String] = []
	for row_index in range(GRID_ROWS):
		match row_index:
			6:
				lines.append("  Game")
			7:
				lines.append("  Over")
			8:
				lines.append("  !!!!")
			_:
				lines.append("")
	$SubViewport/Label.text = "\n".join(lines)

func gen_next_row() -> Array:
	if rows_since_last_obstacle < 2:
		rows_since_last_obstacle += 1
		return [0, 0, 0] # No obstacles in this row
	else:
		roll = randi_range(0, 2)
		if roll == 0:
			rows_since_last_obstacle = 0
			roll = randi_range(0, 2)
			ret = [randi_range(0, 1), randi_range(0, 1), randi_range(0, 1)]
			ret[roll] = 0
			return ret    
		else:
			rows_since_last_obstacle += 1
			return [0, 0, 0]    # No obstacles in this row

#call every second
func update(gen_new_tile=true):
	if(gen_new_tile):
		grid.append(gen_next_row())
		grid.pop_front()
	if(grid[0][pos] == 1): 
		hit()
	else:
		grid[0][pos]=3
	printgrid()
	  ## die!   

func hit():
	hp-=1
	grid[0][pos]=4
	if hp==1:
		$sfxDie1.play()
		cutfinger.emit(9)
	else:
		$sfxDie2.play()
		cutfinger.emit(10)
#func printgrid():
	#print("#-----------------")
	#for row in grid:
		#print(row)
	#print("#-----------------")

#func printgrid():
	#var lines: Array[String] = [""]
	#for row in grid:
		#var cells: Array[String] = []
		#for cell in row:
			#if cell==3:
				#cells.append(str(player_char))
			#if cell==1:
				#cells.append(obstacle_char)
			#if cell==0:
				#cells.append(empty_char)
		#lines.append("[" + "|".join(cells) + "]")
	#$SubViewport/Label.text = "\n".join(lines)

func printgrid():
	var lines: Array[String] = []

	for row_index in range(grid.size() - 1, -1, -1):
		var cells: Array[String] = []

		for cell in grid[row_index]:
			if cell == 3:
				cells.append(str(player_char))
			elif cell == 1:
				cells.append(obstacle_char)
			elif cell == 0:
				cells.append(empty_char)
			elif cell == 4:
				cells.append(damaged_char)
		#lines.append("[" + "|".join(cells) + "]")
		lines.append(" " + " ".join(cells) + " ")

	$SubViewport/Label.text = "\n".join(lines)

#PUBLIC
#move
func press1():
	move(1)

func press2():
	move(-1)

func move(add):
	grid[0][pos] = 0
	pos+=add
	if(pos>2): pos = 0
	if(pos<0): pos = 2
	if(grid[0][pos] == 1): hit()
	grid[0][pos] = 3
	update(false)
