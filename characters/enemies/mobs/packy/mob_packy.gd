extends CharacterBody2D

class_name MobPacky

var health = 75
var damage = 4


const SPEED = 400
var player_chase: bool = false
var is_attacking: bool = false
var atk_on_cooldown: bool = false
var player: CharacterBody2D = null
var pos_before_atk: Vector2

@onready var _animate_sprite = $PackyAniSprite
@onready var _attack_area = $AttackArea
@onready var _attack_timer = $AttackArea/AttackTimer
@onready var _attack_cooldown = $AttackArea/AttackCooldown
var target_position = null
var last_motion = 0.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _ready():
	_animate_sprite.play("idle")

func _physics_process(delta):
	last_motion = get_last_motion()
	
	if not is_on_floor(): velocity.y += gravity * delta
	
	if player_chase: 
		velocity.x = position.direction_to(player.position).x * 100
	else:
		velocity.x = 0
	
	flip_body()
	
	if is_attacking: attack_player()

	move_and_slide()


func _on_packy_detector_body_entered(body):
	player = body
	player_chase = true


func _on_packy_detector_body_exited(body):
	player = null
	player_chase = false

func flip_body() -> void:
	if last_motion.x > 0:
		_animate_sprite.flip_h = true
		_attack_area.get_child(0).position.x = 78
	if last_motion.x < 0:
		_attack_area.get_child(0).position.x = -78
		_animate_sprite.flip_h = false


func _on_attack_area_body_entered(body):
	if body == get_parent().find_child("Player"):
		is_attacking = true
		_attack_timer.start()


func _on_attack_area_body_exited(body):
	_animate_sprite.play("idle")
	is_attacking = false
	player_chase = true


func attack_player() -> void:
	player_chase = false
	
	if _attack_timer.is_stopped() && _attack_cooldown.is_stopped() && !atk_on_cooldown:
		
		is_attacking = true
		_animate_sprite.play("angry")
		get_parent().find_child("Player").health -= damage
		get_parent().find_child("Player").get_node("nicolo").play_hurt_animation()
		atk_on_cooldown = true
		
		if is_attacking && atk_on_cooldown: 
			is_attacking = false
			atk_on_cooldown = false
			_attack_cooldown.start()
			

		print(get_parent().find_child("Player").health)

