extends Node2D


@onready var platform = preload("res://world/platform_full.tscn")
var last_platform_pos = {
	"x": 0.0,
	"y": 0.0
}

func _ready():
	# place the player
	
	# get player position
	
	# put_platform near player
	random_init()
	# put 3 random platform
	random_platform()
	

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
	var platform_direction = 1.0
	var next_platform_x = 0.0
	randomize()
	for i in 8:
		platform_direction = -1 if (randi() % 2) else 1
		next_platform_x = last_platform_pos.x + (400 * platform_direction)
		
		if next_platform_x > 900:
			next_platform_x = next_platform_x - 500
		elif next_platform_x < 200:
			next_platform_x = next_platform_x + 500
		
		rand_platform_x = randf_range(last_platform_pos.x + (250 * platform_direction), next_platform_x)
		rand_platform_y = randf_range(last_platform_pos.y - 100, last_platform_pos.y - 200.0)
		put_platform(
			Vector2(
				rand_platform_x,
				rand_platform_y
			)
		)
		last_platform_pos.x = rand_platform_x
		last_platform_pos.y = rand_platform_y
		print("PLATFORM #", i)
		print(last_platform_pos)
		


func put_platform(pos):
	var new_platform = platform.instantiate()
	new_platform.position = pos
	add_child(new_platform)
	
