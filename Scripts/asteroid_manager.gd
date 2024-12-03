extends Node

@export var LARGE_ASTEROID_A : PackedScene
@export var LARGE_ASTEROID_B : PackedScene
@export var LARGE_ASTEROID_C : PackedScene
@export var MEDIUM_ASTEROID_A : PackedScene
@export var MEDIUM_ASTEROID_B : PackedScene
@export var MEDIUM_ASTEROID_C : PackedScene
@export var SMALL_ASTEROID_A : PackedScene
@export var SMALL_ASTEROID_B : PackedScene
@export var SMALL_ASTEROID_C : PackedScene

@onready var GAME : Node2D = $".."
@onready var ITEM_MANAGER : Node = %"Item Manager"

@onready var children
@onready var asteroidList = [
		LARGE_ASTEROID_A, LARGE_ASTEROID_B, LARGE_ASTEROID_C,
		MEDIUM_ASTEROID_A, MEDIUM_ASTEROID_B, MEDIUM_ASTEROID_C,
		SMALL_ASTEROID_A, SMALL_ASTEROID_B, SMALL_ASTEROID_C
 	]


var screenSize


func _process(_delta: float) -> void:
	children = get_children()
	screenSize = get_viewport().size
	for child in children:
		if child.position.x + 50 < 0 or child.position.x - 50 > screenSize.x:
			child.queue_free()
		if child.position.y + 50 < 0 or child.position.y - 50 > screenSize.y:
			child.queue_free()


func spawn_asteroid():
	# Randomly select an asteroid type
	var asteroidScene = asteroidList[randi() % asteroidList.size()]
	var asteroidInstance = asteroidScene.instantiate()
	asteroidInstance.setup_asteroid(screenSize)
	add_child(asteroidInstance)


func spawn_debris( colorN : Color, sizeN : int, positionN : Vector2):
	var asteroidScene
	if sizeN == 1:
		asteroidScene = asteroidList[(randi() % 3) + 3]
	if sizeN == 0:
		asteroidScene = asteroidList[(randi() % 3) + 6]
	var asteroidInstance = asteroidScene.instantiate()
	asteroidInstance.setup_asteroid(screenSize, colorN)
	asteroidInstance.position = positionN
	call_deferred("add_child", asteroidInstance)


func update_score(colorN, sizeN):
	if colorN == Color("WHITE"):
		GAME.score += sizeN
	if colorN == Color("RED"):
		GAME.score += sizeN * 2
	if colorN == Color("BLUE"):
		GAME.score += sizeN * 3


func spawn_item(positionN : Vector2):
	ITEM_MANAGER.spawn_pack(positionN)


func clear():
	children = get_children()
	for child in children:
		child.queue_free()
