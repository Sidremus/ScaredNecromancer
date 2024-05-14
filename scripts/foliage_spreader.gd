extends Node2D
@export var number_of_copies:int = 128

func _ready() -> void:
	var children = get_children()
	for i in number_of_copies:
		var new_copy = (children.pick_random() as Node2D).duplicate()
		add_child(new_copy)
