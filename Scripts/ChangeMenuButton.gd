extends Button

export(NodePath) var from_path
export(NodePath) var to_path
var from_node
var to_node

func _ready():
	from_node = get_node(from_path)
	to_node = get_node(to_path)

func _pressed():
	from_node.hide()
	to_node.show()
