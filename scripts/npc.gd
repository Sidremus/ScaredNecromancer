extends CharacterBody2D
class_name NPC

var max_health: float = 100.
var curent_health: float

func _ready() -> void:
	curent_health = max_health

func take_damage(_incoming_damage:float):
	pass
