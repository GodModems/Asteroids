extends Node

@onready var children

var screenSize


func _process(_delta: float) -> void:
	children = get_children()
	screenSize = get_viewport().size
	for child in children:
		if child.position.x + 50 < 0 or child.position.x - 50 > screenSize.x:
			child.queue_free()
		if child.position.y + 50 < 0 or child.position.y - 50 > screenSize.y:
			child.queue_free()

func clear():
	children = get_children()
	for child in children:
		child.queue_free()
