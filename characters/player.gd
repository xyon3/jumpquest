extends CharacterBody2D
class_name Player

const TOP_SPEED = 250.0
const TOP_JUMP = 600.0

var speed = 0.0
var jump_velocity = 0.0

# NICOLO STATS
var health = 100
var nico_damage = 20

var is_dealing_damage: bool = false
var lookdir: Vector2 = Vector2(0, 0)

var visible_bullets: Array = []


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var coyote_timer = $coyote_timer
@onready var attack_cooldown = $attack_timer
@onready var sprites = $AnimatedSprite2D
@onready var crosshair = $Crosshair
@onready var nicobullet = preload("res://characters/nicolo/nicobullet.tscn")



func _ready():
	$light_animation.play("breathing_light")
	Global.player_stats["DAMAGE"] = nico_damage
	crosshair.play("default")

func _process(delta):
	if is_dealing_damage: 
		velocity.y -= 10
		velocity.x += 8

func _physics_process(delta):
	implement_gravity(delta)

	
	nico_movement(delta)
	nico_attacks(delta)
	sprites.play("idle")
	

# PHYSICS
func implement_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if (Input.is_action_just_pressed("move_left")):
		velocity.x = -130
	if (Input.is_action_just_pressed("move_right")):
		velocity.x = 130
	
func nico_movement(delta):
	
	if velocity.x != 0 and is_on_floor():
		if velocity.x > 0:
			velocity.x -= 25
			if velocity.x < 25 and velocity.x > -25:
				velocity.x = 0
		if velocity.x < 0:
			velocity.x += 25
			if velocity.x > 25 and velocity.x <= -25:
				velocity.x = 0

	if (Input.is_action_just_pressed("move_up") || Input.is_action_just_pressed("space"))&& (is_on_floor() || not coyote_timer.is_stopped()):
		velocity.y = -TOP_JUMP


	# Handle speed
	if (Input.is_action_just_pressed("move_left") and is_on_floor()) or (Input.is_action_just_pressed("move_right") and is_on_floor()):
		speed = TOP_SPEED

		
	if Input.is_action_pressed("move_left") and is_on_floor():
		if not Input.is_action_pressed("move_up"):
			velocity.x = -300

	# Handle right
	if Input.is_action_pressed("move_right") and is_on_floor():
		if not Input.is_action_pressed("move_up"):
			velocity.x = 300

	var was_on_floor = is_on_floor()
	
	if get_last_motion().x > 0:
		Global.player_stats["DIRECTION"] = 1
		crosshair.flip_h = false
		crosshair.position.x = 37
	elif get_last_motion().x < 0:
		Global.player_stats["DIRECTION"] = -1
		crosshair.flip_h = true
		crosshair.position.x = -37
	else:
		pass
		
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()

func nico_attacks(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && attack_cooldown.is_stopped():
		shoot_bullet()

# STATUS CHANGES
func receive_damage(damage, from_who) -> void:
	health -= damage
	sprites.play("hurt")
	is_dealing_damage = true
	velocity = Vector2(0,0)
	set_physics_process(false)


func _on_animated_sprite_2d_animation_finished():
	if sprites.animation == "hurt":
		set_physics_process(true)
		is_dealing_damage = false
		sprites.play("idle")


func shoot_bullet():
	attack_cooldown.start()

	var bullet = nicobullet.instantiate()
	visible_bullets.append(bullet)
	get_parent().add_child(bullet)
	
	if Global.player_stats["DIRECTION"] > 0:
		bullet.position = Vector2(position.x + 40, position.y)

	else: 
		bullet.position = Vector2(position.x - 40, position.y)
	
	crosshair.play("shooting")
	
	bullet.connect("offscreen", _on_bullet_offscreen)
	

func _on_bullet_offscreen(bullet):
	bullet.queue_free()
