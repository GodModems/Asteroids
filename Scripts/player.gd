extends Sprite2D

@export var acceleration: float = 20.0
@export var rotation_speed: float = 5
@export var max_speed: float = 75.0
@export var friction: float = 0.8
@export var bulletScene: PackedScene
@export var ammo : float
@export var MAGAZINE_SIZE = 30

@onready var RESTOCK: Timer 
@onready var BULLET_MANAGER: Node 

@onready var GAME: Node2D 
@onready var GUN: Polygon2D = $"Gun"

var BARRELS : Array

var velocity: Vector2 = Vector2.ZERO
var screenSize : Vector2
var currentColor : int = 0
var COLOR_LIST : PackedColorArray 
var needRelations : bool = true

var damage = 1

func setup_player(screenSizeN):
	screenSize = screenSizeN
	ammo = MAGAZINE_SIZE
	COLOR_LIST.append(Color("WHITE"))
	COLOR_LIST.append(Color("RED"))
	COLOR_LIST.append(Color("BLUE"))
	set_meta("color", COLOR_LIST[currentColor])
	position = screenSize / 2


func get_relations():
	BULLET_MANAGER = get_parent().find_child("Bullet Manager")
	RESTOCK = find_child("Restock")
	BARRELS.clear()
	for barrel in GUN.get_children():
		BARRELS.append(barrel)
	GAME = get_parent()


func _process(delta: float):
	if needRelations:
		get_relations()
		needRelations = false
	_handle_input(delta)
	_apply_friction(delta)
	_update_position()
	_handle_screen_wrapping()


func _handle_input(delta: float):
	# Rotate the player
	if Input.is_action_pressed("Left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("Right"):
		rotation += rotation_speed * delta
	# Apply thrust
	if Input.is_action_pressed("Thrust"):
		var direction = Vector2.RIGHT.rotated(rotation)
		velocity += direction * acceleration * delta
	# Shoot bullets
	if Input.is_action_just_pressed("Shoot"):
		_shoot_bullet()
	if Input.is_action_just_released("Primary Action"):
		update_color()
	

func _apply_friction(delta):
	velocity -= velocity * friction * delta
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


func _update_position():
	position += velocity


func update_color():
	currentColor = (currentColor + 1) % 3
	GUN.color = COLOR_LIST[currentColor]
	set_meta("color", COLOR_LIST[currentColor]) 


func _handle_screen_wrapping():
	if position.x < 0:
		position.x = screenSize.x
	elif position.x > screenSize.x:
		position.x = 0
	if position.y < 0:
		position.y = screenSize.y
	elif position.y > screenSize.y:
		position.y = 0


func _shoot_bullet():
	if ammo >= currentColor + 1:
		for barrel in BARRELS:
			var bullet = bulletScene.instantiate()
			bullet.setup_bullet(barrel.global_position, barrel.global_position - global_position, COLOR_LIST[currentColor], currentColor + 1)
			BULLET_MANAGER.add_child(bullet)
			update_ammo(-1 * (currentColor + 1))


func update_ammo(amountN):
	if (ammo + amountN) < 30:
		ammo += amountN


func _on_restock_timeout() -> void:
	update_ammo(1)


func _on_hitbox_area_entered(areaN: Area2D) -> void:
	if areaN.get_parent().has_meta("destroyable"):
		if areaN.get_parent().get_meta("destroyable"):
			GAME.game_over()
			queue_free()
