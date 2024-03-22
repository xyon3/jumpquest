extends Node

# questions_store, responsible for storing all questions from the database
var questions_store: Array = []

# current_level, tracks how many questions has been answered
var current_level: int = 0

var wave_type: String = ""
var wave_count: int = 0
var enemies: Array = []

var player_stats: Dictionary = {
	"HP": 0.0,
	"DAMAGE": 0.0,
	"DIRECTION": 1
}
