extends Node2D

export (int) var speed = 20
var velocity = Vector2()
var reach_position = Vector2()
var STEP_SIZE = 64
export (int) var food = 50

const UP 	= 0x0
const RIGHT = 0x1
const DOWN 	= 0x2
const LEFT 	= 0x4

signal killed()

func _ready():
	pass

func check_input():
	if velocity.length_squared() == 0:
		if Input.is_action_just_pressed("move_right"):
			move_any_dir(RIGHT)
		elif Input.is_action_just_pressed("move_down"):
			move_any_dir(DOWN)
		elif Input.is_action_just_pressed("move_left"):
			move_any_dir(LEFT)
		elif Input.is_action_just_pressed("move_up"):
			move_any_dir(UP)
		elif Input.is_action_just_pressed("fight"):
			decrease_food(10)

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

func fight():
	$Animation.animation = "PlayerAttack"
	$Animation.play()
	pass
	
func decrease_food(amount):
	food -= amount
	$Animation.animation = "PlayerDamage"
	$Animation.play()
	if food <= 0:
		emit_signal("killed")
		food = 0

func move_any_dir(dir):
	if dir == UP:
		velocity.y -= 1
		reach_position = Vector2(position.x, position.y - STEP_SIZE)
	elif dir == RIGHT:
		velocity.x += 1
		reach_position = Vector2(position.x + STEP_SIZE, position.y)
	elif dir == DOWN:
		velocity.y += 1
		reach_position = Vector2(position.x, position.y + STEP_SIZE)
	elif dir == LEFT:
		velocity.x -= 1
		reach_position = Vector2(position.x - STEP_SIZE, position.y)
	if velocity.length_squared() != 0:
		$Animation.play()
		$StepTimer.start()
	pass
	
func _on_StepTimer_timeout():
	if $Animation.animation != "Player":
		$Animation.animation = "Player"
		$Animation.stop()

func resolve_collision():
	pass

func _on_Animation_animation_finished():
	$StepTimer.start()
	pass # replace with function body
