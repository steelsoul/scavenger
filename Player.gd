extends Node2D

export (int) var speed = 20
var velocity = Vector2()
var reach_position = Vector2()
const STEP_SIZE = 64
export (int) var food = 50

signal killed()
signal move()
signal quit_level()

func _ready():
	pass

func _process(delta):
	pass
	
func round_to_bound(x, bound):
	var result = int(x + bound/2)
	result -= result % bound
	return result
	
func stop_player():
	$Animation.stop()
	#print(position.x, " ", position.y)
	velocity = Vector2(0, 0)
	position.x = round_to_bound(position.x, STEP_SIZE)
	position.y = round_to_bound(position.y, STEP_SIZE)
	print(position.x, " ", position.y)
	
func move_player(delta):
	if velocity.length() > 0:
		emit_signal("move")
		velocity = velocity.normalized()*speed
		position += velocity * delta
		var dp = position - reach_position
		if dp.length_squared() < 1:
			stop_player()

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
	
func _on_StepTimer_timeout():
	if $Animation.animation != "Player":
		$Animation.animation = "Player"
		$Animation.stop()

func _on_Animation_animation_finished():
	$StepTimer.start()
	pass

func process_input():
	if velocity.length_squared() == 0:
		if Input.is_action_just_pressed("move_right"):
			return Vector2(STEP_SIZE, 0)
		elif Input.is_action_just_pressed("move_down"):
			return Vector2(0, STEP_SIZE)
		elif Input.is_action_just_pressed("move_left"):
			return Vector2(-STEP_SIZE, 0)
		elif Input.is_action_just_pressed("move_up"):
			return Vector2(0, -STEP_SIZE)
	return Vector2(0, 0)

func check_collisions(vec):
	$DirectionRay.cast_to = vec
	$DirectionRay.force_raycast_update()
	if $DirectionRay.is_colliding():
		$DirectionRay.enabled = false
		print("check_collisions: colliding")
		return true
	return false
	pass
	
func get_collider_position(collider):
	var wp = collider.world_to_map(position + Vector2(STEP_SIZE/2, STEP_SIZE/2) + $DirectionRay.cast_to)
	wp.x = floor(wp.x / 2)
	wp.y = floor(wp.y / 2)
	return wp
	
func make_decision(is_collide, dir_vec):
	velocity = dir_vec
	reach_position = position + velocity
	$Animation.play()
	var food_adjustment = -10
	if is_collide:
		var collider = $DirectionRay.get_collider()
		if collider.is_in_group("food"):
			#TODO: replace fn with signal
			collider.get_parent().clear_food_cell(get_collider_position(collider))
			food_adjustment = 50 # fixme: make constant
		elif collider.is_in_group("background"):
			if collider.get_parent().exit_position != get_collider_position(collider):
				stop_player()
				food_adjustment = 0
			else:
				emit_signal("quit_level")
				print("quit level")

	food += food_adjustment
	
	if food <= 0:
		emit_signal("killed")
	pass

func _physics_process(delta):
	var dir_vec = process_input()
	if dir_vec.length_squared() != 0:
		var is_collide = check_collisions(dir_vec)
		make_decision(is_collide, dir_vec)
	move_player(delta)