extends Node2D

@onready var spawner = preload("res://world/enemy_portal/spawn_portal.tscn")
@onready var enemy_packy = preload("res://characters/enemies/mobs/packy/mob_packy.tscn")
@onready var qna_scene = preload("res://world/scenes/qna_scene.tscn")

@onready var _player = $Player
@onready var _label_player = $CanvasLayer/LabelPlayer
@onready var _common_label = $CanvasLayer/CommonLabel

var wave_just_cleared = false
var is_initial = true
var current_wave = 0
var wave_is_done: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	_label_player.play("init")
	_common_label.text = Global.wave_type + " WAVES"
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wave_is_done = Global.wave_count < current_wave
	
	if _player.position.y > 800:
		_player.velocity = Vector2(0,0)
		_player.position = Vector2(1152/2, -100)
	
	#print("Enemies: ", Global.enemies.size())
	#print("WAVE: ", Global.wave_count)
	#print("CURR_WAVE: ", current_wave)
	
	if wave_is_done:
		_label_player.play("end_msg")
		_common_label.text = "Proceeding to next question..."
	
	print("BEFORE DEFAULT: ", current_wave)
	if Global.enemies.size() <= 0 and !wave_is_done and !is_initial:
			_label_player.play("default")
			_common_label.text = "Wave "+ str(current_wave + 1) + " of " + str( Global.wave_count )
	

	
	pass

func wave():
	print("WAVE_IS_DONE: ", wave_is_done)
	
	if !wave_is_done:
		on_wave_complete()
		call_wave()
	
	print("Enemies: ", Global.enemies.size())
	print("WAVE: ", Global.wave_count)

func call_wave():
	randomize()
	if Global.enemies.size() <= 0 and !wave_is_done:
		for i in range(4):
			spawn_enemy("packy", Vector2(randf_range(200, 900), randf_range(0, 360)))
			

func spawn_enemy(enemy_name, spawner_pos):
	var mob_entity = null
	
	match enemy_name:
		"packy": mob_entity = enemy_packy.instantiate()
	
	mob_entity.position = spawner_pos
	add_child(mob_entity)
	Global.enemies.append(mob_entity)
	pass

func on_wave_complete():
	if Global.enemies.size() == 0:
		wave_just_cleared = true
	if wave_just_cleared:
		current_wave += 1

		wave_just_cleared = false
	pass



func _on_label_player_animation_finished(anim_name):
	if current_wave > Global.wave_count:
		_label_player.play("end_msg")
		
	if anim_name == "end_msg":
		Global.current_level += 1
		wave_cleanup()
		get_tree().change_scene_to_file("res://world/scenes/qna_scene.tscn")
		
	if anim_name == "init":
		_label_player.play("next_init")
		_common_label.text = "Wave "+ str(current_wave + 1) + " of " + str( Global.wave_count )
		is_initial = false
		
	if anim_name == "next_init" || anim_name == "default" && !wave_is_done:
		wave()
		

		
	print(anim_name)
	print("Enemies: ", Global.enemies.size())
	print("WAVE: ", Global.wave_count)
	print("CURR_WAVE: ", current_wave)


func wave_cleanup():
	Global.wave_type= ""
	Global.wave_count = 0
	Global.enemies = []
