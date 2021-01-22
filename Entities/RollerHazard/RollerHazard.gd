extends Node2D


onready var _digit_sheet = load("res://Entities/Digit/DigitSheet.tscn")
onready var _squish_zone = $RollerHazardBody2D/SquishZone

# Called when the node enters the scene tree for the first time.
func _ready():
	_squish_zone.connect("body_entered", self, "_body_in_danger")
	$RollerHazardBody2D/DigitSprite.hide()
	$RollerHazardBody2D/RollingAnimation.play("Run")


func _body_in_danger(body):
	if(body.has_method("die")):
		body.die()
		$RollerHazardBody2D/DigitSquishPlayer.play("SquishDigit")


func _spawn_pancake():
	var new_sheet = _digit_sheet.instance()
	new_sheet.velocity.x = scale.x
	new_sheet.global_position = $RollerHazardBody2D/SheetSpawnPoint.global_position
	get_tree().root.add_child(new_sheet)
	
