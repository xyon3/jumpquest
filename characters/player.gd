extends CharacterBody2D
class_name Player

const TOP_SPEED = 250.0
const TOP_JUMP = 600.0

var speed = 0.0
var jump_velocity = 0.0

# Nicolo stats
var health = 100
var damage = 20


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var coyote_timer = $coyote_timer

func _ready():
	$light_animation.play("breathing_light")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if (Input.is_action_just_pressed("move_left")):
			velocity.x = -130
		if (Input.is_action_just_pressed("move_right")):
			velocity.x = 130
		
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

	if Input.is_action_just_pressed("ui_accept") && (is_on_floor() || not coyote_timer.is_stopped()):
		velocity.y = -TOP_JUMP


	# Handle speed
	if (Input.is_action_just_pressed("move_left") and is_on_floor()) or (Input.is_action_just_pressed("move_right") and is_on_floor()):
		speed = TOP_SPEED

		
	if Input.is_action_pressed("move_left") and is_on_floor():
		if not Input.is_action_pressed("ui_accept"):
			velocity.x = -300

	# Handle right
	if Input.is_action_pressed("move_right") and is_on_floor():
		if not Input.is_action_pressed("ui_accept"):
			velocity.x = 300
			
	#print(get_position_delta())

	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	get_node("nicolo").play_idle_animation()
