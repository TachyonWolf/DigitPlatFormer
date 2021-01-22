extends Node2D
tool

export(int, 0, 1000) onready var width setget set_width
export(int, -360, 360) onready var angle setget set_angle
export var speed = 10

func set_width(new_value : int):
	width = new_value
	$StaticBody2D/Sprite.texture.region = Rect2( 0, 0, 16 * width, 16 )
	$StaticBody2D/CollisionShape2D.shape.extents = Vector2(8 * width, 8)

func set_angle(new_value : int):
	angle = new_value
	_heading = Vector2(cos(deg2rad(angle)), sin(deg2rad(angle)))
	if(abs(angle) > 90):
		$StaticBody2D/Sprite.flip_v = true
	$StaticBody2D.rotation_degrees = angle
	$StaticBody2D.constant_linear_velocity = _heading * speed

var _heading = Vector2.RIGHT

func _ready():
	$StaticBody2D.constant_linear_velocity = _heading * speed
	set_angle(angle)
	set_width(width)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		$StaticBody2D/Sprite.texture.region.position.x -= speed * delta
	if not Engine.editor_hint:
		$StaticBody2D/Sprite.texture.region.position.x -= speed * delta
