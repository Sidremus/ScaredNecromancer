extends AnimatedSprite2D
@export var sprite_sheet_row_range:=Vector2i(1,5)
@export var spread_range_multiplyer:float = 2.
@export var randomize_position:= true

func _ready() -> void:
	var random_int:int = randi_range(sprite_sheet_row_range.x,sprite_sheet_row_range.y)
	var random_float:float = randfn(.5,.2)
	play(str(random_int))
	speed_scale = lerpf(.1,.45, random_float)
	if random_int == 4:
		modulate = Color.ORANGE.lerp(Color.RED, random_float)
	elif random_int == 5:
		modulate = Color.GRAY.lerp(Color.DIM_GRAY, random_float)
		speed_scale = 0.
	elif random_int > 5:
		modulate = Color.WHITE.lerp(Color.DARK_GRAY, random_float)
	else:
		modulate = Color.YELLOW_GREEN.lerp(Color.WEB_GREEN, random_float)
	
	scale.x = lerpf(1.3 * scale.x,.7 * scale.x, random_float)
	scale.y = scale.x
	frame = randi_range(0,15)
	flip_h = random_float > .5
	if randomize_position:
		position.x = lerpf(-get_viewport_rect().size.x * .5,get_viewport_rect().size.x * .5,randfn(.5,.2)) * spread_range_multiplyer
		position.y = lerpf(-get_viewport_rect().size.y * .5,get_viewport_rect().size.y * .5,randfn(.5,.2)) * spread_range_multiplyer
