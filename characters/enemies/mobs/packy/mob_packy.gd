extends CharacterBody2D

class_name MobPacky

var health = 40
var damage = 1
const mob_point: int = 20

const SPEED = 150
var player_chase: bool = false
var is_attacking: bool = false
var atk_on_cooldown: bool = false
var player: CharacterBody2D = null
var direction_to_player: float = 0.0
var player_vicinity: float
var pos_before_atk: Vector2

@onready var _animate_sprite = $PackyAniSprite
@onready var _attack_area = $AttackArea
@onready var _attack_timer = $AttackArea/AttackTimer
@onready var _attack_cooldown = $AttackArea/AttackCooldown
@onready var _patrol_timer = $PatrolTimer
var target_position = null
var last_motion = 0.0

var wave_count = Global.wave_count



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _ready():
	_animate_sprite.play("idle")

func _physics_process(delta):
	last_motion = get_last_motion()
	
	if not is_on_floor(): velocity.y += gravity * delta

	player_follow()
	
	
	if position.y > 800:
		Global.enemies.erase(self)
		self.queue_free()
	
	flip_body()
	
	if is_attacking && !Global.player_stats["is_invincible"]: attack_player(damage)

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
		player_chase = false
		_attack_timer.start()


func _on_attack_area_body_exited(body):
	_animate_sprite.play("idle")
	is_attacking = false
	player_chase = true


func attack_player(damage) -> void:
	#player_chase = false
	if is_on_floor():
		if _attack_timer.is_stopped() && _attack_cooldown.is_stopped() && !atk_on_cooldown:
			
			is_attacking = true
			_animate_sprite.play("angry")
			get_parent().find_child("Player").receive_damage(damage, "mob_packy")
			atk_on_cooldown = true
			
			if is_attacking && atk_on_cooldown: 
				is_attacking = false
				atk_on_cooldown = false
				player_follow()
				_attack_cooldown.start()


func _on_hit_box_body_entered(body):
	if body.name == "nicobullet":
		receive_damage(body.damage)
		body.queue_free()
	pass

func receive_damage(damage):
	if health <= 0: 
		Global.enemies.erase(self)
		if Global.wave_type == "NORMAL": Global.points += mob_point
		get_parent().find_child("BasePoint").text = str(Global.points)
		self.queue_free()
		return
	health -= damage

func patrol():
	randomize()

	velocity.x = randf_range(-10, 10)
	_patrol_timer.start()

func player_follow():
	if player_chase and player != null: 
			direction_to_player = position.direction_to(player.position).x
			velocity.x =  direction_to_player * SPEED
	else:
		# INSERT PttATROL HERE\
		if _patrol_timer.is_stopped():
			patrol()
