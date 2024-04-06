extends Control

@onready var base_point_compo = $BasePoint
# Called when the node enters the scene tree for the first time.
func _ready():
	base_point_compo.text = str(Global.points)
