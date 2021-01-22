extends "res://Entities/KinematicPlatformerController2D.gd"

var state_machine : AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("facing_changed", self, "_on_facing_changed")
	DigitsManager.add_digit(self)
	listen_to_input = false
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true


func _process(delta):
	var on_floor = is_on_floor()
	if !on_floor:
		state_machine.travel("flutter")
	else:
		state_machine.travel("idle")

func _on_facing_changed(facing_right : bool):
	$Sprite.flip_h = !facing_right
	if(facing_right):
		$Sprite.offset.x = -4
	else:
		$Sprite.offset.x = 4
