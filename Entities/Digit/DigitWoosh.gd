extends AudioStreamPlayer

var fling_sound

func _ready():
	fling_sound = load("res://Entities/Digit/sounds/fling.ogg")

func play_fling():
	if stream != fling_sound:
		stream = fling_sound
	if !playing:
		play()

func stop_fling():
	if stream == fling_sound:
		stop()
