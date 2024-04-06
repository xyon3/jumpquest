extends Node

# questions_store, responsible for storing all questions from the database
var questions_store: Array = []
var question_answered: Array = []

var points: int = 500

# current_level, tracks how many questions has been answered
var current_level: int = 0

var wave_type: String = ""
var wave_count: int = 0
var enemies: Array = []

var player_stats: Dictionary = {
	"HP": 0.0,
	"DAMAGE": 0.0,
	"DIRECTION": 1,
	
	"is_invincible": false,
	
	"in_tutorial": true
}



var player_control: Dictionary = {
	"move_up": Input.is_action_pressed("ui_up") || Input.is_action_pressed("move_up") || Input.is_action_pressed("ui_accept"),
	"move_down": Input.is_action_pressed("ui_down") || Input.is_action_pressed("move_down"),
	"move_left": Input.is_action_pressed("ui_left") || Input.is_action_pressed("move_left"),
	"move_right": Input.is_action_pressed("ui_right") || Input.is_action_pressed("move_right"),
	
	
}


