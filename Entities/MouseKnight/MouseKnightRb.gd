extends RigidBody2D

const WALK_ACCEL = 1600.0
const WALK_DEACCEL = 1600.0
const WALK_MAX_VELOCITY = 240.0
const AIR_ACCEL = 1600.0
const AIR_DEACCEL = 800.0
const JUMP_VELOCITY = 380
const STOP_JUMP_FORCE = 450.0
const MAX_FLOOR_AIRBORNE_TIME = 0.15

var siding_left = false
var jumping = false
var stopping_jump = false
var airborne_time = 1e20
var floor_h_velocity = 0.0

func _integrate_forces(body_state : Physics2DDirectBodyState):
	var current_linear_velocity : Vector2 
	current_linear_velocity = body_state.get_linear_velocity() 
	var step = body_state.get_step()
	
	var new_siding_left = siding_left
	
	var movement_input := Vector2()  # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		movement_input.x += 1
	if Input.is_action_pressed("move_left"):
		movement_input.x -= 1
	var jump = Input.is_action_pressed("jump")
	
	# Deapply prev floor velocity.
	current_linear_velocity.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal).
	var found_floor = false
	var floor_index = -1
	var contact_count = body_state.get_contact_count()
	for x in range(contact_count):
		var ci = body_state.get_contact_local_normal(x)
		
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	
	if found_floor:
			airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air.
		
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME
	
	# Process jump.
	if jumping:
		if current_linear_velocity.y > 0:
			# Set off the jumping flag if going down.
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			current_linear_velocity.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor.
		if movement_input.x < 0:
			if current_linear_velocity.x > -WALK_MAX_VELOCITY * abs(movement_input.x):
				current_linear_velocity.x -= WALK_ACCEL * step
		elif movement_input.x > 0:
			if current_linear_velocity.x < WALK_MAX_VELOCITY * abs(movement_input.x):
				current_linear_velocity.x += WALK_ACCEL * step
		else:
			var xv = abs(current_linear_velocity.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			current_linear_velocity.x = sign(current_linear_velocity.x) * xv
	
			# Check jump.
		if not jumping and jump:
			current_linear_velocity.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
	
	else:
		# Process logic when the character is in the air.
		if movement_input.x < 0:
			if current_linear_velocity.x > -WALK_MAX_VELOCITY:
				current_linear_velocity.x -= AIR_ACCEL * step
		elif movement_input.x > 0:
			if current_linear_velocity.x < WALK_MAX_VELOCITY:
				current_linear_velocity.x += AIR_ACCEL * step
		else:
			var xv = abs(current_linear_velocity.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			current_linear_velocity.x = sign(current_linear_velocity.x) * xv
	
	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = body_state.get_contact_collider_velocity_at_position(floor_index).x
		current_linear_velocity.x += floor_h_velocity
	
	if (current_linear_velocity.x > 0):
		$Sprite.flip_h = false
	elif (current_linear_velocity.x < 0):
		$Sprite.flip_h = true
	
	# Finally, apply gravity and set back the linear velocity.
	current_linear_velocity += body_state.get_total_gravity() * step
	body_state.set_linear_velocity(current_linear_velocity)
