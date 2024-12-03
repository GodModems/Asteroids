extends Sprite2D

@export var linearVelocity : Vector2
@export var angularVelocity : float
@export var speed : int = 300
@export var damage : int

func setup_bullet(positionN : Vector2, directionN : Vector2, colorN : Color, damageN : int):
	position = positionN
	linearVelocity = directionN.normalized() * speed
	modulate = colorN
	damage = damageN
	set_meta("color", colorN) 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += linearVelocity.x * delta
	position.y += linearVelocity.y * delta
	rotation += angularVelocity * delta


func _on_hitbox_area_entered(areaN: Area2D) -> void:
	
	if areaN.get_parent().has_meta("destroyable"):
		if areaN.get_parent().get_meta("destroyable"):
			areaN.get_parent().hit(damage)
			queue_free()
