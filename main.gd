extends Node2D

# Main Scene
# What:
# - Simple platformer
# When:
# - No Time Limit
# Goal: 
# - Reach the portal



@onready var platform = preload("res://world/platform/platform_full.tscn")
@onready var portal_platform = preload("res://world/platform/potal_platform/portal_platform.tscn")
@onready var qna_scene = preload("res://world/scenes/qna_scene.tscn").instantiate()

var last_platform_pos = {
	"x": 0.0,
	"y": 0.0
}

@onready var player = $Player

func _ready():
	# Initialize first platform
	random_init()
	
	# Put 3 random platform
	random_platform()
	# Put the portal platform
	put_portal_platform()
	




func _process(delta):
	if (player.position.y < -648):
		print("OVER 648")
	
	portal_change_scene()



func random_init():
	var init_platform_x = randf_range(200, 800)
	var init_platform_y = 450.0
	randomize()
	put_platform(
		Vector2(
			init_platform_x,
			init_platform_y,
		)
	)
	last_platform_pos.x = init_platform_x
	last_platform_pos.y = init_platform_y
	
	print (last_platform_pos)

func random_platform():
	var rand_platform_x = 0.0
	var rand_platform_y = 0.0
	randomize()
	for i in 4:
		var rand_platform_pos = new_platform_position()
		
		rand_platform_x = rand_platform_pos.x
		rand_platform_y = rand_platform_pos.y
		
		put_platform(
			Vector2(
				rand_platform_x,
				rand_platform_y
			)
		)
		last_platform_pos.x = rand_platform_x
		last_platform_pos.y = rand_platform_y


func put_platform(pos):
	var new_platform = platform.instantiate()
	new_platform.position = pos
	add_child(new_platform)


func put_portal_platform():
	# [TODO] Add change scene when portal is used by player

	var rand_platform_pos = new_platform_position()
	var new_portal = portal_platform.instantiate()
	new_portal.position = Vector2(rand_platform_pos.x, rand_platform_pos.y)
	add_child(new_portal)


func new_platform_position():
	randomize()
	var rand_platform_x = 0.0
	var rand_platform_y = 0.0
	var platform_direction = 1.0
	var next_platform_x = 0.0
	
	platform_direction = -1 if (randi() % 2) else 1
	
	next_platform_x = last_platform_pos.x + (400 * platform_direction)
	
	if next_platform_x > 900:
		next_platform_x = next_platform_x - 600
	elif next_platform_x < 200:
		next_platform_x = next_platform_x + 600
	
	rand_platform_x = randf_range(last_platform_pos.x + (250 * platform_direction), next_platform_x)
	rand_platform_y = randf_range(last_platform_pos.y - 150, last_platform_pos.y - 175.0)
	
	return {
		"x" :rand_platform_x,
		"y" :rand_platform_y
	}
	
func portal_change_scene():
	if get_node("portal_platform").find_child("Area2D").overlaps_body(player):
		get_tree().change_scene_to_file("res://world/scenes/qna_scene.tscn")
		
