extends Control

func _input(event):
	if event is InputEventMouse:
		return
	if event.is_action_pressed("ui_cancel"):
		if(visible):
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func _on_Resume_pressed():
	hide()
	get_tree().paused = false

func _on_Menu_pressed():
	get_tree().paused = false
	DigitsManager.clear_digits()
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")
