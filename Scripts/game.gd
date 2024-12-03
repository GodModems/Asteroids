extends Node2D


@export var PLAYER : PackedScene

@export var screenSize : Vector2
@export var score : int

@export var SPAWN_INTERVAL: float = 2.0 # Time between spawns

@onready var ASTEROID_MANAGER : Node = %"Asteroid Manager"
@onready var BULLET_MANAGER : Node = %"Bullet Manager"
@onready var UI_MANAGER : Control = $"UI Manager"

var asteroidList = []
var running : bool


func _ready():
	screenSize = get_viewport().size
	UI_MANAGER.set_menu_ui()
	set_process(false)


func _process(delta: float):
	SPAWN_INTERVAL -= delta
	if SPAWN_INTERVAL <= 0:
		screenSize = get_viewport().size
		ASTEROID_MANAGER.spawn_asteroid()
		SPAWN_INTERVAL = 2.0  # Reset interval



func spawn_player():
	var playerInstance = PLAYER.instantiate()
	playerInstance.setup_player(screenSize)
	add_child(playerInstance)


func start_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	score = 0
	screenSize = get_viewport().size
	spawn_player()
	set_process(true)
	UI_MANAGER.set_game_ui()


func game_over():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	screenSize = get_viewport().size
	set_process(false)
	ASTEROID_MANAGER.clear()
	BULLET_MANAGER.clear()
	UI_MANAGER.set_gameover_ui()


func get_player():
	var curChildren = get_children()
	return curChildren[5]




func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_pressed() -> void:
	start_game()


func _on_start_button_pressed() -> void:
	start_game()
