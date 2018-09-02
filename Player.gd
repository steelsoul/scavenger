extends Node2D

export (int) var speed = 20
var velocity = Vector2()
var reach_position = Vector2()
var STEP_SIZE = 64
export (int) var food = 50

enum DIRECTION{D_UP, D_RIGHT, D_DOWN, D_LEFT}
enum COLLISION{CN_FOOD, CN_WALL, CN_MONSTER, CN_EXIT, CN_NONE}

var collider
var collider_type = CN_NONE
var collider_position = Vector2()

signal killed()
signal move()

func _ready():
	pass

func check_input():
	if velocity.length_squared() == 0:
		if Input.is_action_just_pressed("move_right"):
			move_any_dir(D_RIGHT)
		elif Input.is_action_just_pressed("move_down"):
			move_any_dir(D_DOWN)
		elif Input.is_action_just_pressed("move_left"):
			move_any_dir(D_LEFT)
		elif Input.is_action_just_pressed("move_up"):
			move_any_dir(D_UP)
		elif Input.is_action_just_pressed("fight"):
			decrease_food(10)

func _process(delta):
#	check_input()
	#move_player(delta)
	pass
	
func round_to_bound(x, bound):
	var result = int(x + bound/2)
	result -= result % bound
	return result
	
func move_player(delta):
	if velocity.length() > 0:
		emit_signal("move")
		velocity = velocity.normalized()*speed
		position += velocity * delta
		var dp = position - reach_position
		if dp.length_squared() < 1:
			$Animation.stop()
			#print(position.x, " ", position.y)
			velocity = Vector2(0, 0)
			position.x = round_to_bound(position.x, STEP_SIZE)
			position.y = round_to_bound(position.y, STEP_SIZE)
			print(position.x, " ", position.y)

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
	if velocity.length() > 0:
		return

	reach_position = position
	var move_to = Vector2(0, 0)
	if dir == D_UP:
		move_to = Vector2(0, -1)
	elif dir == D_RIGHT:
		move_to = Vector2(1, 0)
	elif dir == D_DOWN:
		move_to = Vector2(0, 1)		
	elif dir == D_LEFT:
		move_to = Vector2(-1, 0)
	
	velocity = move_to * STEP_SIZE
	$DirectionRay.enabled = true
	$DirectionRay.cast_to = move_to * STEP_SIZE
#	$DirectionRay.force_raycast_update()

	if velocity.length_squared() != 0:
		$Animation.play()
		$StepTimer.start()
	
	reach_position = position + velocity
#	print("RP: ", reach_position)
	if collider_type != CN_NONE:
		print("colliding with ", collider_type)
	pass
	
func _on_StepTimer_timeout():
	if $Animation.animation != "Player":
		$Animation.animation = "Player"
		$Animation.stop()

func _on_Animation_animation_finished():
	$StepTimer.start()
	pass # replace with function body

func update_map():
	if collider_type == CN_FOOD:
		var wp = collider.world_to_map(collider_position)
		wp.x = floor(wp.x / 2)
		wp.y = floor(wp.y / 2)
		print("UM: tileset pos: ", wp)
		collider.get_parent().clear_food_cell(wp)
	
func check_collisions_old():
	if $DirectionRay.enabled:
		if $DirectionRay.is_colliding():
			$DirectionRay.enabled = false
			print("colliding")
			collider = $DirectionRay.get_collider()
			if collider.is_in_group("food"):
	#			print("food")
	#			print("collider is", collider)
	#			print("player position: ", position)
				
				var canvas_transform = get_viewport().get_canvas_transform()
				var wp = collider.world_to_map(position + Vector2(STEP_SIZE/2, STEP_SIZE/2) + $DirectionRay.cast_to)
				wp.x = floor(wp.x / 2)
				wp.y = floor(wp.y / 2)
				print("tileset pos: ", wp)
				
				#collider.get_parent().clear_food_cell(wp)
				
				collider_position = position + Vector2(STEP_SIZE/2, STEP_SIZE/2) + $DirectionRay.cast_to
				collider_type = CN_FOOD	
		else: # No colliding
			collider_type = CN_NONE

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
	
func make_decision(is_collide, dir_vec):
	velocity = dir_vec
	reach_position = position + velocity
	$Animation.play()
	if is_collide:
		var collider = $DirectionRay.get_collider()
		if collider.is_in_group("food"):
			var canvas_transform = get_viewport().get_canvas_transform()
			var wp = collider.world_to_map(position + Vector2(STEP_SIZE/2, STEP_SIZE/2) + $DirectionRay.cast_to)
			wp.x = floor(wp.x / 2)
			wp.y = floor(wp.y / 2)
			collider.get_parent().clear_food_cell(wp)
	pass

func _physics_process(delta):
	var dir_vec = process_input()
	if dir_vec.length_squared() != 0:
		var is_collide = check_collisions(dir_vec)
		make_decision(is_collide, dir_vec)		
		if is_collide: update_map()
	move_player(delta)
		