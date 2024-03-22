extends CharacterBody2D


signal offscreen(bullet)

var damage: float = Global.player_stats.get("DAMAGE")
var dir: float = Global.player_stats.get("DIRECTION")



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = dir * 600
	if position.x <= 0 || position.x >= 1152: emit_signal("offscreen", self)
	move_and_slide()
