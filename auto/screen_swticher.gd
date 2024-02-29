extends Node

var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(0)
	
func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
