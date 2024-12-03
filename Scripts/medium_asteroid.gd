extends Sprite2D

@export var linearVelocity : Vector2
@export var angularVelocity : float
@export var health : int

var speed : float


# Called when the node enters the scene tree for the first time.
func setup_asteroid(screenSizeN : Vector2, colorN : Color = pick_color()):
	var spawnPosition = _random_screen_edge_position(screenSizeN)
	var direction = (random_screen_center(screenSizeN) - spawnPosition).normalized()
	var rot = randf_range(-1, 1)
	speed = randfn(60.0, 7.0)
	position = spawnPosition
	linearVelocity = direction * speed
	angularVelocity = rot
	set_color(colorN)
	set_health(colorN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += linearVelocity.x * delta
	position.y += linearVelocity.y * delta
	rotation += angularVelocity * delta

func pick_color() -> Color:
	var random_float = randf()
	if random_float < 0.5:
		return Color("WHITE")
	elif random_float < 0.8:
		return Color("RED")
	else:
		return Color("BLUE")


func set_color(colorN):
	modulate = colorN
	set_meta("color", colorN)


func set_health(colorN):
	if colorN == Color("WHITE"):
		health = 3
	if colorN == Color("RED"):
		health = 5
	if colorN == Color("BLUE"):
		health = 7


func _random_screen_edge_position(screenSizeN : Vector2) -> Vector2:
	var edge = randi() % 4
	match edge:
		0: return Vector2(randf() * screenSizeN.x, -50)					# Top edge
		1: return Vector2(randf() * screenSizeN.x, screenSizeN.y + 50)	# Bottom edge
		2: return Vector2(-50, randf() * screenSizeN.y)					# Left edge
		3: return Vector2(screenSizeN.x + 50, randf() * screenSizeN.y)	# Right edge
	return Vector2.ZERO


# Utility function to calculate a random point near the center for direction
func random_screen_center(screenSizeN : Vector2) -> Vector2:
	return screenSizeN / 2 + Vector2(randf_range(-100, 100), randf_range(-100, 100))


func hit(damageN):
	health -= damageN
	if health <= 0:
		var parent = get_parent()
		var color = get_meta("color")
		parent.update_score(color, 3)
		parent.spawn_debris(color, 0, position)
		parent.spawn_debris(color, 0, position)
		destroy()


func destroy():
	queue_free()
