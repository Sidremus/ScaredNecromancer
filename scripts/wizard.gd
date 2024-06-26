extends CharacterBody2D
class_name Wizard

@export var speed:float = 210.
@export var acceleration:float = 4.5

@onready var wizard_sprite: AnimatedSprite2D = $AnimatedSprite

var fireball_scene:= preload("res://scenes/fireball_with_area.tscn")
var input_vec:Vector2
var active_summon_locations:Array[SummonLocation] = []

func _physics_process(delta: float) -> void:
	input_vec.x = Input.get_axis("left","right")
	input_vec.y = Input.get_axis("up","down")
	velocity = velocity.lerp(input_vec.limit_length(1.) * speed, acceleration * delta)
	move_and_slide()
	
	if input_vec.length() > 0.:
		if wizard_sprite.animation == "idle":
			wizard_sprite.play("run")
			wizard_sprite.set_frame(randi_range(0,15))
		wizard_sprite.flip_h = signf(input_vec.x) < 0
	else:
		if wizard_sprite.animation == "run":
			wizard_sprite.play("idle")
			wizard_sprite.set_frame(randi_range(0,15))
	wizard_sprite.speed_scale = clampf((velocity.length()/(speed*delta)) * 2., .1,1.)


func shoot_fireball():
	var fireball_instance:Fireball = (fireball_scene.instantiate() as Fireball)
	fireball_instance.the_wizard_who_cast_me = self
	fireball_instance.fireball_goal_position = get_global_mouse_position()
	wizard_sprite.set_frame_progress(1.)
	add_child(fireball_instance)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("summon"):
		if active_summon_locations.size() > 0:
			active_summon_locations.pick_random().summon()
	if event.is_action_pressed("fireball"):
		shoot_fireball()
