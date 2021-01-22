extends Node2D


export(float, 0, 20) var wait_time = 2.5
export(float, 0, 20) var offset_time = 2.5
export(float, 0, 10) var pistion_speed = 1
var running := true
var _time_till_run := 0.0 
onready var _pancake = load("res://Entities/Digit/DigitPancake.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _time_till_run = offset_time
	$PistonBody/AnimationPlayer.playback_speed = pistion_speed

func reset_playback_speed():
	$PistonBody/AnimationPlayer.playback_speed = 1

func _process(delta):
	var crushed_digit = false
	#if the player is not playing count down
	if(!$PistonBody/AnimationPlayer.current_animation && running):
		_time_till_run -= delta
		$PistonBody/AnimationPlayer.playback_speed = pistion_speed
	#when the count down hits zero
	if(_time_till_run < 0):
		_time_till_run = wait_time
		for body in $PistonBody/SquashZone.get_overlapping_bodies():
			if(body.has_method("die")):
				body.die()
				crushed_digit = true
		if(!crushed_digit):
			$PistonBody/AnimationPlayer.play("Run")
		else:
			$PistonBody/AnimationPlayer.play("Crush and flutter")


func _spawn_pancake():
	var new_pancake = _pancake.instance()
	new_pancake.global_position = $PistonBody/PancakeSpawnPoint.global_position
	get_tree().root.add_child(new_pancake)
