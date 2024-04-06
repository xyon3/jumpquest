extends Node2D


@onready var total_points = $TotalPoints

# Called when the node enters the scene tree for the first time.
func _ready():
	$BgFull/AnimationPlayer.play("bg_move")
	total_points.text = str(Global.points)

