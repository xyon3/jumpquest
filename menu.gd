extends Control



func _ready():
	print("DEBUGGING")

func _process(delta):
	animate_menu()


func animate_menu():
	$Label2/label_animation.play("menu_animate")
