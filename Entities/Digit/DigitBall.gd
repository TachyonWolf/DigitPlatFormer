extends "res://Entities/KinematicPlatformerController2D.gd"

var roll_speed = 20

func _ready():
	listen_to_input = false
	connect("on_bounce", self, "bounce")
	DigitsManager.connect("digit_focused", self, "digit_selected")
	DigitsManager.add_digit(self)

func bounce(velocity):
	roll_speed = abs(velocity.length() / 10)
	if velocity.x < 0:
		roll_speed *= -1

func _process(delta):
	$Sprite.rotate(roll_speed * delta)
	if(is_on_floor()):
		roll_speed = velocity.x / 10

func digit_selected(digit):
	listen_to_input = digit == self
