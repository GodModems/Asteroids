extends Sprite2D

@export var linearVelocity : Vector2
@export var angularVelocity : float
@export var speed : int = 300
@export var damage : int

func setup_pack(positionN : Vector2):
	position = positionN


func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(areaN: Area2D) -> void:
	if areaN.get_parent().has_meta("destroyable"):
		if areaN.get_parent().get_meta("destroyable"):
			queue_free()
	if areaN.get_parent().has_meta("player"):
		areaN.get_parent().ammo = (areaN.get_parent().MAGAZINE_SIZE)
		queue_free()
