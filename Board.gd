extends Node2D

var FLOOR_DIC = {}
var WALL_DIC = {}
var FOOD_DIC = {}
var OUTER_WALL_DIC = {}
const FLOOR_COUNT = 8
const OUTER_WALL_COUNT = 4
const WALL_COUNT = 14
const FOOD_COUNT = 2
var exit_position = Vector2()

export (int) var BOARD_SIZE = 8

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
	make_any_dic("Floor", FLOOR_COUNT, FLOOR_DIC)
	make_any_dic("Wall", WALL_COUNT, WALL_DIC)
	make_any_dic("Food", FOOD_COUNT, FOOD_DIC)
	make_any_dic("OuterWall", OUTER_WALL_COUNT, OUTER_WALL_DIC)

func make_any_dic(item_name, item_count, item_dic):
	for x in range(1, item_count + 1):
		var name = item_name + str(x)
		var value = $Background.tile_set.find_tile_by_name(name)
		item_dic[x-1] = value

func prepare_board():
	for x in range(0, BOARD_SIZE):
		for y in range(0, BOARD_SIZE):
			if x == 0 || x == BOARD_SIZE-1 || y == 0 || y == BOARD_SIZE-1:
				var index = randi() % OUTER_WALL_COUNT
				$Background.set_cell(x, y, OUTER_WALL_DIC[index])
			else:
				var index = randi() % FLOOR_COUNT
				$Background.set_cell(x, y, FLOOR_DIC[index])
	var door_index =  $Background.tile_set.find_tile_by_name("Exit")
	exit_position = Vector2(BOARD_SIZE - 1, BOARD_SIZE-2)
	$Background.set_cellv(exit_position, door_index)

func setup_enemies():
	var enemies_count = int(log(level))
	var xpos = randi() % 6 + 1
	var ypos = randi() % 6 + 1
	pass
	
func setup_food():
	var food_amount = 2 + randi() % int(log(BOARD_SIZE))
	for i in range(0, food_amount + 1):
		var index = randi() % FOOD_COUNT
		var xp = (randi() % (BOARD_SIZE-2)) + 1;
		var yp = (randi() % (BOARD_SIZE-2)) + 1;
		$FOOD.set_cell(xp, yp, FOOD_DIC[index]);
	pass
	
func clear_food_cell(v2):
	print("will clear: ", v2)
	var index = 28 - $FOOD.get_cellv(v2)
	$FOOD.set_cellv(v2, -1)
# cell disappear
	var pos = 2 * $FOOD.map_to_world(v2) + Vector2(32, 32)
	$ModifiedSprite.play_sprite_animation(index)
	$ModifiedSprite.position = pos


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
