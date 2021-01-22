extends Node2D

onready var _digit = load("res://Entities/Digit/Digit.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("respawn")):
		var new_digit = _digit.instance()
		new_digit.global_position = $DigitSpawn.global_position
		add_child(new_digit)
