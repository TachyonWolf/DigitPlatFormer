extends "res://Scripts/SmoothFallowCamera.gd"

func _ready():
	DigitsManager.connect("digit_focused", self, "digit_selected")

func digit_selected(digit):
	target = digit
