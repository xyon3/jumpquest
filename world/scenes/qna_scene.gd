extends Node2D

# QNA scene:
# - has a timer
# - wrong portals will kill the player and change the main_scene to punish the player
# - correct portals will change the scene to main_scene with mobs and good utils

@onready var player: CharacterBody2D = $Player

@onready var question_text: Label = $CanvasLayer2/question_text

@onready var wave_battle = preload("res://world/scenes/wave_battle.tscn").instantiate()

@onready var portal_platforms = [
	$portal_platform, 
	$portal_platform2, 
	$portal_platform3, 
	$portal_platform4
]

var question = Global.questions_store[Global.current_level]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$moving_platform/platform.move_platform()
	print(question)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y > 600:
		get_tree().reload_current_scene()
		
	assign_question_data(
		question.text,
		question.choices,
		question.correct_answer
	)


func assign_question_data(text, choices, answer):
	question_text.text = "Question:\n" + text
	
	for x in range(choices.size()):
		portal_platforms[x].find_child("Label").text = choices[x]
		if choices[x] == answer:
			if portal_platforms[x].find_child("Area2D").overlaps_body(player):
				get_tree().change_scene_to_file("res://world/scenes/wave_battle.tscn")
				Global.wave_count = 3
				Global.wave_type = "NORMAL"
		else:
			if portal_platforms[x].find_child("Area2D").overlaps_body(player):
				Global.wave_count = 6
				Global.wave_type = "PUNISHMENT"
				get_tree().change_scene_to_file("res://world/scenes/wave_battle.tscn")
