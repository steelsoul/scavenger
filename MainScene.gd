extends Node2D

func _ready():
	$Player.position = $StartPosition.position
	pass

func _process(delta):
#	$Player.move_player(delta, $Board.position)
#	if Input.is_action_just_pressed("move_right"):
#		$Player.move_any_dir($Player.RIGHT)
#	elif Input.is_action_just_pressed("move_down"):
#		$Player.move_any_dir($Player.DOWN)
#	elif Input.is_action_just_pressed("move_left"):
#		$Player.move_any_dir($Player.LEFT)
#	elif Input.is_action_just_pressed("move_up"):
#		$Player.move_any_dir($Player.UP)
#	elif Input.is_action_just_pressed("fight"):
#		$Player.fight()
		
#	if $Player.position.x + $Board.position.x + 32 > 32*$Board.BOARD_SIZE:
#		$Board.position.x -= 1
#	elif $Player.position.x - $Board.position.x + 32 > 32*$Board.BOARD_SIZE:
#		$Board.position.x += 1
#
#	if $Player.position.y + $Board.position.y + 32 > 32*$Board.BOARD_SIZE:
#		$Board.position.y -= 1
#	elif $Player.position.y - $Board.position.y + 32 > 32*$Board.BOARD_SIZE:
#		$Board.position.y += 1
		
	#$Board.position 
	pass
	