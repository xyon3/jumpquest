extends CharacterBody2D


const TOP_SPEED = 250.0
const TOP_JUMP = 630.0


var speed = 0.0
var jump_velocity = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if (Input.is_action_just_pressed("move_left")):
			velocity.x -= 30
		if (Input.is_action_just_pressed("move_right")):
			velocity.x += 30
		
	#print($".".position)
	if velocity.x != 0 and is_on_floor():
		if velocity.x > 0:
			velocity.x -= 25
			if velocity.x < 25 and velocity.x > -25:
				velocity.x = 0
		if velocity.x < 0:
			velocity.x += 25
			if velocity.x > 25 and velocity.x <= -25:
				velocity.x = 0




	if Input.is_action_just_released("ui_accept") and is_on_floor():
		get_tree().create_timer(1.0).timeout 
		velocity.y -= jump_velocity


	# Handle speed
	if (Input.is_action_just_pressed("move_left") and is_on_floor()) or (Input.is_action_just_pressed("move_right") and is_on_floor()):
		speed = TOP_SPEED

	if is_on_floor():	
	# Handle left.
		if Input.is_action_just_released("move_left"):
			velocity.x -= speed
	# Handle right
		if Input.is_action_just_released("move_right"):
			velocity.x += speed
		# JUMP
		if Input.is_action_just_pressed("ui_accept"):
			jump_velocity = TOP_JUMP 
			speed = TOP_SPEED
		
	if Input.is_action_pressed("move_left") and is_on_floor():
		if not Input.is_action_pressed("ui_accept"):
			velocity.x = -150

	# Handle right
	if Input.is_action_pressed("move_right") and is_on_floor():
		if not Input.is_action_pressed("ui_accept"):
			velocity.x = 150
			
	#print(get_position_delta())

	move_and_slide()
	get_node("nicolo").play_idle_animation()
