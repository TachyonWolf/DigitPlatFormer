extends Node2D

export var spin := 10

func _physics_process(delta):
	$RigidBody2D.rotate(spin * delta)
