extends Node3D
# var rows_since_last_obstacle = 0

# func gen_next_row -> Array[spot]:
#     if(rows_since_last_obstacle < 2):
#         rows_since_last_obstacle += 1
#         return [0, 0, 0] # No obstacles in this row
#     else:
#         roll = randi_range(0, 2)
#         if(roll == 0):
#             rows_since_last_obstacle = 0
#             return [roll(0,1), 0, 0]    #every cube has 50-50 to be obstacle # Obstacle in lane 0
#         else
#             rows_since_last_obstacle++
#             return [0, 0, 0]    #every cube has 50-50 to be obstacle # Obstacle in lane 1
