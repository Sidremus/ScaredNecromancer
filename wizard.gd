extends CharacterBody2D
class_name Wizard

@export var speed:float = 210.
@export var acceleration:float = 4.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var input_vec:Vector2

func _physics_process(delta: float) -> void:
	input_vec.x = Input.get_axis("left","right")
	input_vec.y = Input.get_axis("up","down")
	velocity = velocity.lerp(input_vec.limit_length(1.) * speed, acceleration* delta)
	move_and_slide()
	
	if input_vec.length() > 0.:
		if animated_sprite.animation == "idle":
			animated_sprite.play("run")
			animated_sprite.set_frame(randi_range(0,15))
		animated_sprite.flip_h = signf(input_vec.x) < 0
	else:
		if animated_sprite.animation == "run":
			animated_sprite.play("idle")
			animated_sprite.set_frame(randi_range(0,15))
	animated_sprite.speed_scale = clampf((velocity.length()/(speed*delta)) * 2., .1,1.)
