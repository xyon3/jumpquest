extends Control

@onready var q_one = $QONE
@onready var q_two = $QTWO
@onready var q_three = $QTHREE
@onready var q_four = $QFOUR
@onready var q_five = $QFIVE

@onready var q_level = [
	q_one,
	q_two,
	q_three,
	q_four,
	q_five
]

var lbl:Label 

# Called when the node enters the scene tree for the first time.
func _ready():
	print(q_level)
	print(Global.question_answered)
	if Global.question_answered.size():
		for a in Global.question_answered:
			lbl = q_level[a["index"]]
			if a["res"]: 
				lbl.add_theme_color_override("font_color", Color(0, 179, 0))
			else: 
				lbl.add_theme_color_override("font_color", Color.CRIMSON)
			
