extends NPC
class_name Skeleton

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var the_wizard_who_summoned_me:Wizard
var origin_summon_location:SummonLocation
var ref_color:Color
var ref_scale:Vector2

func _ready() -> void:
	super._ready()
	var rand_nr:float = randf()
	modulate = Color.PALE_GREEN.lerp(Color.LIME_GREEN, rand_nr)
	ref_color = modulate
	modulate.a = 0.
	sprite.flip_h = rand_nr >.5
	sprite.scale *= lerpf(1.3,1.8, rand_nr)
	ref_scale = sprite.scale
	var spawn_tween = get_tree().create_tween()
	spawn_tween.tween_property(self, "modulate", Color(modulate, 1.), 1.)

func _on_animated_sprite_2d_animation_finished() -> void:
	if curent_health <=0: return
	if sprite.animation == "summon":
		sprite.play("idle_rare") if randf()>.7 else sprite.play("idle_common")


func _on_animated_sprite_2d_animation_looped() -> void:
	if curent_health <=0: return
	if sprite.animation == "idle_common":
		var r = randf()
		sprite.flip_h = r >.5
		if r>.7:
			sprite.speed_scale = 1.
			sprite.play("idle_rare")
		else:
			sprite.speed_scale = lerpf(.7,1.3,r)
			sprite.play("idle_common")

func death_sequence():
	sprite.play_backwards("summon")
	
	await sprite.animation_finished
	sprite.pause()
	sprite.frame = 0
	
	var death_tween = get_tree().create_tween()
	death_tween.tween_property(self, "modulate", Color(ref_color *.5, ref_color.a), 1.)
	death_tween.tween_property(self, "modulate", Color(ref_color *.1, 0.), 8.)
	
	await death_tween.step_finished
	sprite.z_index = -10
	origin_summon_location.gain_summon(1)
	origin_summon_location.sprite.flip_h = !sprite.flip_h 
	origin_summon_location.modulate = Color.WHITE
	origin_summon_location.sprite.speed_scale = origin_summon_location.ref_speed_scale * 2.7 if origin_summon_location.has_wizard else origin_summon_location.ref_speed_scale * 1.
	
	await death_tween.finished
	queue_free()

func take_damage(_incoming_damage:float):
	if curent_health < 0: return
	curent_health -= _incoming_damage
	modulate = Color.RED
	var damage_tween = get_tree().create_tween()
	damage_tween.set_parallel(true)
	damage_tween.tween_property(self, "modulate", Color.WHITE, .1)
	damage_tween.tween_property(sprite, "scale", sprite.scale * 1.3, .1)
	damage_tween.chain().tween_property(sprite, "scale", ref_scale, .2)
	damage_tween.tween_property(self, "modulate", ref_color, .2)
	if curent_health < 0: death_sequence()
