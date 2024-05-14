extends Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D2

func _on_body_entered(body: Node2D) -> void:
	if body is Wizard:
		animated_sprite.play("open")
		collision_shape.set_deferred("disabled", true)


func _on_body_exited(body: Node2D) -> void:
	if body is Wizard:
		animated_sprite.play("close")
		collision_shape.set_deferred("disabled", false)
