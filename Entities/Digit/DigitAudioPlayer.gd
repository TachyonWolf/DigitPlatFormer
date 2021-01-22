extends AudioStreamPlayer


var step_sounds

func _ready():
	step_sounds = [load("res://Entities/Digit/sounds/step1.ogg"), load("res://Entities/Digit/sounds/step2.ogg")]


func play_random_footstep():
	var number = (randi() % 2)
	stream = step_sounds[number]
	play()


