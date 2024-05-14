extends Area2D
class_name Fireball

@export var fireball_speed:float = 810.
@onready var fireball_sprite: AnimatedSprite2D = $FireballSprite

var fireball_starting_position:Vector2
var fireball_goal_position:Vector2
var the_wizard_who_cast_me:Wizard
var check_for_bodies:bool = false

func _physics_process(_delta: float) -> void:
	if check_for_bodies:
		check_for_bodies = false
		var hit_bodies = get_overlapping_bodies()
		var collision_debug_string:String = ""
		if hit_bodies.size() != 0:
			collision_debug_string = name + " hit: "
			for i in hit_bodies.size():
				if i == 0:
					collision_debug_string += hit_bodies[i].name
				else:
					collision_debug_string += " | " + hit_bodies[i].name
		else:
			collision_debug_string = name + " hit nothing"
		print_debug("\n" + collision_debug_string)

func _process(_delta: float) -> void:
	queue_redraw()
	if fireball_sprite.animation == "Summon":
		var flip_side:bool = the_wizard_who_cast_me.global_position.x > fireball_goal_position.x
		fireball_sprite.flip_h = flip_side
		position = Vector2(20,0) if !flip_side else Vector2(-20,0)
		var animation_progrss_lerp:float = (fireball_sprite.frame as float) / fireball_sprite.sprite_frames.get_frame_count("Summon")
		modulate = Color.TOMATO.lerp(Color.WHITE, animation_progrss_lerp)
	else:
		fireball_sprite.modulate = Color.FIREBRICK.lerp(Color.LIGHT_YELLOW, absf(sin(Time.get_unix_time_from_system() * 16.)))

func _ready() -> void:
	name = "Fireball "+str(get_rid().get_id())
	fireball_sprite.play("Summon")
	await fireball_sprite.animation_finished
	
	fireball_sprite.play("Flight")
	if the_wizard_who_cast_me.wizard_sprite.animation == "idle": the_wizard_who_cast_me.wizard_sprite.flip_h = fireball_sprite.flip_h
	fireball_starting_position = to_global(position)
	top_level = true
	global_position = fireball_starting_position
	fireball_sprite.flip_h = fireball_goal_position.x < fireball_starting_position.x
	var life_time:float = fireball_goal_position.distance_to(fireball_starting_position) / fireball_speed
	
	var fireball_tween = get_tree().create_tween()
	fireball_tween.set_ease(Tween.EASE_IN)
	fireball_tween.set_trans(Tween.TRANS_QUINT)
	fireball_tween.tween_property(self, "global_position", fireball_goal_position, life_time)
	
	await fireball_tween.finished
	check_for_bodies = true
	fireball_tween = get_tree().create_tween()
	fireball_tween.set_ease(Tween.EASE_OUT_IN)
	fireball_tween.set_trans(Tween.TRANS_BOUNCE)
	fireball_tween.tween_property(fireball_sprite, "scale", Vector2(3.5,3.5),.1)
	fireball_tween.set_parallel(true)
	fireball_tween.chain().tween_property(fireball_sprite, "scale", Vector2(4.,4.), .15)
	fireball_tween.tween_property(fireball_sprite, "self_modulate", Color.TRANSPARENT, .1)
	await fireball_tween.finished
	queue_free()

func _draw() -> void:
	if fireball_sprite.animation == "Summon":
		var target_pos:Vector2 = to_local(fireball_goal_position)
		draw_line(target_pos + Vector2.RIGHT * 35., target_pos - Vector2.RIGHT * 35., Color.FIREBRICK.lerp(Color.WHITE, absf(sin(Time.get_unix_time_from_system() * 12.))))
		draw_line(target_pos + Vector2.UP * 35., target_pos - Vector2.UP * 35., Color.FIREBRICK.lerp(Color.WHITE, absf(sin(Time.get_unix_time_from_system() * 12.))))

