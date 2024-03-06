extends CharacterBody2D


const SPEED = 10
var player_chase = false
var player = null

@onready var _animate_sprite = $PackyAniSprite
var target_position = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _ready():
	_animate_sprite.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor(): velocity.y += gravity * delta
	
	if player_chase: 
		target_position = (player.position - position) * SPEED
		velocity = target_position
		
	move_and_slide()


func _on_packy_detector_body_entered(body):
	player = body
	player_chase = true


func _on_packy_detector_body_exited(body):
	player = null
	player_chase = false
