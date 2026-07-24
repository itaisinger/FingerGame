extends Node3D
var GRID_ROWS = 10
var pos = 0
var rows_since_last_obstacle = 0
var grid = []
var timer := 0.0
var roll = 0
var ret
var display: Label
func _ready() -> void:
	for i in range(10):
		grid.append([0, 0, 0])


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		press2()
	elif Input.is_action_just_pressed("ui_right"):
		press1()
	timer += delta
	if timer >= 1.0:
		timer -= 1.0
		update()

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
func update():
	grid.append(gen_next_row())
	grid.pop_front()
	if(grid[0][pos] == 1): 
		print("Game Over!")
	else:
		grid[0][pos]="P"

	printgrid()
	  ## die!   

func printgrid():
	print("#-----------------")
	for row in grid:
		print(row)
	print("#-----------------")


#PUBLIC
#move
func press1():
	pos+=1
	if(pos>2): pos = 0
	update()

func press2():
	pos-=1
	if(pos<0): pos = 2
	update()
