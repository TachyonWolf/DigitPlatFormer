extends "res://Entities/KinematicPlatformerController2D.gd"

export (PackedScene) var Puff

var state_machine : AnimationNodeStateMachinePlayback

var selected := false
var mobile := true

func spawn_puff():
	var new_puff = Puff.instance()
	new_puff.global_position = $FootPoint.global_position
	get_tree().root.add_child(new_puff)

func _ready():
	listen_to_input = false
	connect("facing_changed",self, "_on_facing_changed")
	connect("on_jump", self, "_on_jump")
	connect("on_land", self, "_on_land")
	connect("on_hit_wall", self, "_on_hit_wall")
	DigitsManager.connect("digit_focused", self, "digit_selected")
	state_machine = $AnimationTree.get("parameters/playback")
	DigitsManager.add_digit(self)
	$AnimationTree.active = true
	$DigitAudio.volume_db = -28
	$DigitWoosh.volume_db = -20

func digit_selected(digit):
	listen_to_input = digit == self

func _process(delta):
	if !run_basic_phsyics: 
		return
	var on_floor = is_on_floor()
	
#	if on_floor && is_on_ceiling():
#		state_machine.travel("floor_splat")
#		run_basic_phsyics = false
#		listen_to_input = false
#		$CollisionShape2D.disabled = true
#		$CollisionShape2D2.disabled = true
#		return
	
	if(on_floor):
		$AnimationTree.set("parameters/run/TimeScale/scale", abs(velocity.x)/90)
		if(abs(velocity.x) > 0.1):
			if  state_machine.get_current_node() != "run":
				state_machine.travel("run")
		else:
			state_machine.travel("idle")
	else:
		state_machine.travel("falling")
	if velocity.length() > 400:
		_start_fling()
	else:
		_stop_fling()

func _on_jump(velocity):
	state_machine.travel("jump")

func _on_land(velocity):
	if abs(velocity.y) > 1000:
		state_machine.travel("floor_splat")
		run_basic_phsyics = false
		listen_to_input = false
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true
	else:
		spawn_puff()
		state_machine.travel("land")

func _on_facing_changed(facing_right : bool):
	$Sprite.flip_h = !facing_right
	if(facing_right):
		$Sprite.offset.x = -4
	else:
		$Sprite.offset.x = 4

func _on_hit_wall(velocity):
	if abs(velocity.x) > 1000:
		run_basic_phsyics = false
		listen_to_input = false
		state_machine.travel("wall_splat")
		$CollisionShape2D.disabled = true
		$CollisionShape2D2.disabled = true

func _start_fling():
	$DigitWoosh.play_fling()

func _stop_fling():
	$DigitWoosh.stop_fling()

func die():
	DigitsManager.remove_digit(self)
	queue_free()
