extends Camera2D

var target : Node2D

export (float) var factor_x = 1
export (float) var factor_y = 1
export(int) var offset_x = 0
export(int) var offset_y = 0

func _physics_process(delta):
	if !target:
		return
	position.x = lerp(position.x, target.position.x + offset_x, delta * factor_x)
	position.y = lerp(position.y, target.position.y + offset_y, delta * factor_y)

