extends Node


signal digit_focused(digit)

var current : Node2D
var digits

# Called when the node enters the scene tree for the first time.
func _ready():
	digits = []
	pass # Replace with function body.


func add_digit(digit : Node2D):
	digits.append(digit)
	if(digits.size() == 0 || !current):
		current = digit
		emit_signal("digit_focused", digit)

func remove_digit(digit : Node2D):
	if digit == current:
		current = null
		emit_signal("digit_focused", null)
	digits.erase(digit)

func clear_digits():
	digits = []

func _process(delta):
	if(Input.is_action_just_pressed("next_digit")):
		if(digits.size() == 0):
			return
		if(digits.size() > 0 && !current):
			current = digits[0]
		var current_num = digits.find(current,0)
		current_num += 1
		var count = digits.size()
		if(current_num >= count):
			current_num = 0
		var selected_digit = digits[current_num]
		current = selected_digit
		emit_signal("digit_focused", selected_digit)
	elif(Input.is_action_just_pressed("prev_digit")):
		if(digits.size() == 0):
			return
		if(digits.size() > 0 && !current):
			current = digits[0]
		var current_num = digits.find(current)
		current_num -= 1
		var count = digits.size()
		if(current_num <= 0):
			current_num = count - 1
		var selected_digit = digits[current_num]
		current = selected_digit
		emit_signal("digit_focused", selected_digit)
