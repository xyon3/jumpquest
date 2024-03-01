extends Node2D



@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	$moving_platform/platform.move_platform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y > 600:
		get_tree().reload_current_scene()



