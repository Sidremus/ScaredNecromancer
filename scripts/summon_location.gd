extends Area2D
class_name SummonLocation

var has_wizard:bool = false
var the_wizard_who_last_checked_in:Wizard
var spawn_radius:float = 150.
var ref_speed_scale:float = 1.
var ref_sprite_scale:float = 1.
var summons_left:int

@export var summoned_unit = preload("res://scenes/skeleton.tscn")
@export var number_of_summons:int =6
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D2

func _ready() -> void:
	summons_left = number_of_summons
	ref_sprite_scale = sprite.scale.x
	await get_tree().create_timer(.1).timeout
	ref_speed_scale = sprite.speed_scale

func _physics_process(_delta: float) -> void:
	queue_redraw()
	if has_wizard && summons_left > 0:
		modulate = Color.WHITE.lerp(Color.GREEN_YELLOW, absf(sin(Time.get_unix_time_from_system() * 15.5 + get_rid().get_id())))
		sprite.scale = Vector2(ref_sprite_scale, ref_sprite_scale) * lerpf(1.1,1.3, absf(sin(Time.get_unix_time_from_system() * 8.5 + get_rid().get_id())))
	else:
		modulate = Color.WHITE
		sprite.scale = Vector2(ref_sprite_scale, ref_sprite_scale)

func _on_body_entered(body: Node2D) -> void:
	if body is Wizard:
		the_wizard_who_last_checked_in = body
		has_wizard = true
		sprite.speed_scale = ref_speed_scale * 2.7 if summons_left > 0 else ref_speed_scale * .5
		if !the_wizard_who_last_checked_in.active_summon_locations.has(self):
			the_wizard_who_last_checked_in.active_summon_locations.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body is Wizard:
		sprite.speed_scale = ref_speed_scale * 1. if summons_left > 0 else ref_speed_scale * .5
		has_wizard = false
		if the_wizard_who_last_checked_in.active_summon_locations.has(self):
			the_wizard_who_last_checked_in.active_summon_locations.erase(self)

func summon():
	if summons_left > 0:
		if has_wizard:
			var summoned_unit_instance = summoned_unit.instantiate()
			if summoned_unit_instance is Skeleton:
				summoned_unit_instance.the_wizard_who_summoned_me = the_wizard_who_last_checked_in
				summoned_unit_instance.add_collision_exception_with(the_wizard_who_last_checked_in)
				summoned_unit_instance.origin_summon_location = self
			get_tree().get_root().add_child(summoned_unit_instance)
			summoned_unit_instance.position = global_position + Vector2.RIGHT.rotated(randf()*TAU) * randf_range(spawn_radius*.5,spawn_radius)
			summons_left -=1
			if summons_left <1:
				sprite.speed_scale = ref_speed_scale * .5
				modulate = Color.DIM_GRAY
				sprite.flip_h = !sprite.flip_h
	if summons_left <= 0 && the_wizard_who_last_checked_in != null:
		if the_wizard_who_last_checked_in.active_summon_locations.has(self):
			the_wizard_who_last_checked_in.active_summon_locations.erase(self)

func gain_summon(amount:int):
	summons_left += amount
	number_of_summons = max(summons_left, number_of_summons)
	if has_wizard:
		if !the_wizard_who_last_checked_in.active_summon_locations.has(self):
			the_wizard_who_last_checked_in.active_summon_locations.append(self)

func _draw() -> void:
	if number_of_summons ==1:
		var pos:= Vector2(0., -60)
		draw_circle(pos,6., Color.WHITE)
		if summons_left == 0:
			draw_circle(pos,5, Color.BLACK)
	else:
		for i in range(number_of_summons):
			var pos:= Vector2(0., -50)
			if number_of_summons ==1:
				pos += Vector2(i * 50. / (number_of_summons - 1) - 25, 0.)
				pos +=Vector2(0.,-10.)
			elif number_of_summons >1: 
				pos += Vector2(i * 50. / (number_of_summons - 1) - 25, 0.)
				pos +=Vector2(0.,- 25.*sin(lerpf(0.,PI, (i as float) / (number_of_summons-1 as float))))
			draw_circle(pos,6., Color.WHITE)
		for i in absi(summons_left-number_of_summons):
			var pos:= Vector2(0., -50)
			if number_of_summons ==1:
				pos += Vector2(i * 50. / (number_of_summons - 1) - 25, 0.)
				pos +=Vector2(0.,-10.)
			elif number_of_summons >1: 
				pos += Vector2(i * 50. / (number_of_summons - 1) - 25, 0.)
				pos +=Vector2(0.,- 25.*sin(lerpf(0.,PI, (i as float) / (number_of_summons-1 as float))))
			draw_circle(pos,5, Color.BLACK)
