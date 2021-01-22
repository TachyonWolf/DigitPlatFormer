extends KinematicBody2D


onready var _digit_ball = load("res://Entities/Digit/DigitBall.tscn")
onready var _squish_zone = $SquishZone

export var fire_speed = Vector2(4000, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	_squish_zone.connect("body_entered", self, "_body_in_danger")
	$DigitSprite.hide()

func _body_in_danger(body):
	if(body.has_method("die")):
		body.die()
		$AnimationPlayer.play("ball_digit")

func spawn_ball():
	var new_ball = _digit_ball.instance()
	new_ball.velocity.x = scale.x * fire_speed.x
	new_ball.velocity.y = fire_speed.y
	new_ball.global_position = $BallSpawnPoint.global_position
	get_tree().root.add_child(new_ball)
