extends Node

onready var parent : KinematicBody2D = get_parent()

func _process(delta):
	for i in parent.get_slide_count():
		var collision = parent.get_slide_collision(i)
		var collider = collision.collider
		if collider is TileMap:
			var tileMap : TileMap = collider
			var cell = tileMap.get_cellv(collision.position - (Vector2.DOWN * 10))
			print(cell)
