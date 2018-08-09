extends Node2D

export (int) var rows = 8
export (int) var columns = 8

var gridPositions = PoolVector2Array()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	init_positions()
	$Player.position = $StartPosition.position
	pass

func init_positions():
	gridPositions.resize(0)
	for x in range(1, columns-1):
		for y in range(1, rows-1):
			gridPositions.append(Vector2(x, y))
	#$Animation.set(
	
func generate_map():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
