extends Node2D

var FLOOR_DIC = {}
var WALL_DIC = {}
var LUT_DIC = {}
var FLOOR_COUNT = 8
var WALL_COUNT = 18
var LUT_COUNT = 2
var BOARD_SIZE = 8

export (int) var level = 0 

func _ready():
	randomize()
	level += 1
	setup_dictionaries()
	prepare_board()
	setup_enemies()
	setup_food()
	pass
	
func setup_dictionaries():
	make_floor_dic()
	make_wall_dic()
	make_lut_dic()

func make_floor_dic():
	for x in range(1, FLOOR_COUNT + 1):
		var name = "Floor" + str(x)
		var value = $Background.tile_set.find_tile_by_name(name)
		FLOOR_DIC[x-1] = value
	pass

func make_wall_dic():
	for x in range(1, WALL_COUNT + 1):
		var name = "Wall" + str(x)
		var value = $Background.tile_set.find_tile_by_name(name)
		WALL_DIC[x-1] = value
	
func make_lut_dic():
	for x in range(1, LUT_COUNT + 1):
		var name = "Food" + str(x)
		var value = $LUT.tile_set.find_tile_by_name(name)
		LUT_DIC[x-1] = value

func prepare_board():
	for x in range(0, BOARD_SIZE):
		for y in range(0, BOARD_SIZE):
			if x == 0 || x == 7 || y == 0 || y == 7:
				var index = randi() % WALL_COUNT
				$Background.set_cell(x, y, WALL_DIC[index])
			else:
				var index = randi() % FLOOR_COUNT
				$Background.set_cell(x, y, FLOOR_DIC[index])
	var door_index =  $Background.tile_set.find_tile_by_name("Exit")
	$Background.set_cell(BOARD_SIZE - 1, BOARD_SIZE-2, door_index)

func setup_enemies():
	var enemies_count = int(log(level))
	var xpos = randi() % 6 + 1
	var ypos = randi() % 6 + 1
	pass
	
func setup_food():
	var lut_amount = randi() % 5
	for i in range(0, lut_amount + 1):
		var index = randi() % LUT_COUNT
		var xp = (randi() % (BOARD_SIZE-2)) + 1;
		var yp = (randi() % (BOARD_SIZE-2)) + 1;
		$LUT.set_cell(xp, yp, LUT_DIC[index]);
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
