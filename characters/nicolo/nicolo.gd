extends Node2D

@onready var player = preload("res://characters/player.tscn")

func play_idle_animation():
	$AnimationPlayer.play("idle")
	
func play_hurt_animation():
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("hurt")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		print(anim_name+ " FINISHED")
		player.name
		$AnimationPlayer.play("idle")
	
