extends CharacterBody2D
class_name Wizard

@export var speed:float = 210.
@export var acceleration:float = 4.5

@onready var wizard_animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var fireball: AnimatedSprite2D = $Fireball

var input_vec:Vector2

@export var fireball_speed:float = 1510.
var fireball_start:Vector2
var fireball_goal:Vector2

func _physics_process(delta: float) -> void:
	input_vec.x = Input.get_axis("left","right")
	input_vec.y = Input.get_axis("up","down")
	velocity = velocity.lerp(input_vec.limit_length(1.) * speed, acceleration * delta)
	move_and_slide()
	
	if input_vec.length() > 0.:
		if wizard_animated_sprite.animation == "idle":
			wizard_animated_sprite.play("run")
			wizard_animated_sprite.set_frame(randi_range(0,15))
		wizard_animated_sprite.flip_h = signf(input_vec.x) < 0
	else:
		if wizard_animated_sprite.animation == "run":
			wizard_animated_sprite.play("idle")
			wizard_animated_sprite.set_frame(randi_range(0,15))
	wizard_animated_sprite.speed_scale = clampf((velocity.length()/(speed*delta)) * 2., .1,1.)

func _process(_delta: float) -> void:
	if fireball.animation == "Summon":
		fireball.flip_h = wizard_animated_sprite.flip_h
		fireball.position = Vector2(20,0) if !wizard_animated_sprite.flip_h else Vector2(-20,0)

func shoot_fireball():
	fireball.top_level = false
	fireball.position = Vector2(20,0) if !wizard_animated_sprite.flip_h else Vector2(-20,0)
	fireball.play("Summon")
	fireball.show()
	await fireball.animation_finished
	
	fireball.play("Flight")
	fireball_start = to_global(fireball.position)
	fireball_goal = get_global_mouse_position()
	fireball.top_level = true
	fireball.flip_h = fireball_goal.x < fireball_start.x
	
	var fireball_tween = get_tree().create_tween()
	var distance:float = fireball_goal.distance_to(fireball_start)
	fireball.global_position = fireball_start
	fireball_tween.tween_property(fireball, "global_position", fireball_goal, distance/fireball_speed)
	await fireball_tween.finished
	
	fireball.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fireball"):
		shoot_fireball()
