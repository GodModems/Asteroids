extends Node

@export var AMMO_PACK : PackedScene

func spawn_pack(positionN : Vector2):
	var ammoPackInstance = AMMO_PACK.instantiate()
	ammoPackInstance.setup_pack(positionN)
	call_deferred("add_child", ammoPackInstance)
