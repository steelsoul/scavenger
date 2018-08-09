extends Area2D

export (int) var speed = 20
var velocity = Vector2()
var reach_position = Vector2()
var STEP_SIZE = 64

func _ready():
	pass

func check_input():
	if velocity.length_squared() == 0:
		if Input.is_action_pressed("ui_right"):
			move_right()
		elif Input.is_action_pressed("ui_down"):
			move_down()
		elif Input.is_action_pressed("ui_left"):
			move_left()
		elif Input.is_action_pressed("ui_up"):
			move_up()

func _process(delta):
	check_input()
	move_player(delta)
	pass
	
func round_to_bound(x, bound):
	var result = int(x + bound/2)
	result -= result % bound
	return result
	
func move_player(delta):
	if velocity.length() > 0:
		velocity = velocity.normalized()*speed
		position += velocity * delta
		var dp = position - reach_position
		if dp.length_squared() < 1:
			$Animation.stop()
			#print(position.x, " ", position.y)
			velocity = Vector2(0, 0)
			position.x = round_to_bound(position.x, STEP_SIZE)
			position.y = round_to_bound(position.y, STEP_SIZE)
			#print(position.x, " ", position.y)
			pass
	pass
	
func move_down():
	velocity.y += 1
	reach_position = Vector2(position.x, position.y+STEP_SIZE)
	$Animation.play()
	$StepTimer.start()
	pass
	
func move_right():
	velocity.x += 1
	reach_position = Vector2(position.x+STEP_SIZE, position.y)
	$Animation.play()
	$StepTimer.start()
	pass
	
func move_up():
	velocity.y -= 1
	reach_position = Vector2(position.x, position.y-STEP_SIZE)
	$Animation.play()
	$StepTimer.start()
	pass
	
func move_left():
	velocity.x -= 1
	reach_position = Vector2(position.x-STEP_SIZE, position.y)
	$Animation.play()
	$StepTimer.start()

func _on_StepTimer_timeout():
	#$Animation.stop()
	pass # replace with function body

func resolve_collision():
	pass

func _on_Player_body_shape_entered(body_id, body, body_shape, area_shape):
	print("oops: ", int(position.x/STEP_SIZE), ", ", int(position.y/STEP_SIZE)) 
	resolve_collision()
	pass # replace with function body
