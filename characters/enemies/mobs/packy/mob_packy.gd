extends CharacterBody2D

class_name MobPacky

var health = 300
var damage = 404


const SPEED = 200
var player_chase = false
var player = null

@onready var _animate_sprite = $PackyAniSprite
var target_position = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _ready():
	_animate_sprite.play("idle")

func _physics_process(delta):
	
	if not is_on_floor(): velocity.y += gravity * delta
	print(player_chase)
	if player_chase: 
		velocity.x = position.direction_to(player.position).x * 100
	else:
		velocity.x = 0
		
	move_and_slide()


func _on_packy_detector_body_entered(body):
	player = body
	player_chase = true


func _on_packy_detector_body_exited(body):
	player = null
	player_chase = false
