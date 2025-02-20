class_name Projectile
extends BasicBubble

var animation_timer : Timer
var animation_start_pos : Vector2
var animation_end_pos : Vector2

var direction := Vector2i(1, 0)
var wave_dir = 1

func _ready() -> void:
	super()
	class_type = "Projectile"
	animation_timer = Timer.new()
	add_child(animation_timer)
	

func _process(delta: float) -> void:
	if animation_timer.is_stopped():
		return
	var distance = animation_end_pos - animation_start_pos
	var rel = 1 - (animation_timer.time_left / animation_timer.wait_time)
	var orth = distance.orthogonal().normalized()
	position = animation_start_pos + distance * rel + orth * sin(rel * PI) * 5 * wave_dir
	

func _update_sprite(old_size):
	return


func check_burst():
	return true

func spawn_animation():
	if Engine.is_editor_hint(): return # TODO not sure if needed
	
	#print("Spawn animation start: ", self)
	show()
	#print("Spawn animation finished: ", self)
	

func burst():
	print("Projectile burst")
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	bursting = true
	remove_from_group("goal")
	#var tween = create_tween().set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "position", position + 32*Vector2(direction), 0.3)
	#print("awaiting tween")
	#await tween.finished
	#print("tween done")
	animation_start_pos = position
	animation_end_pos = position + 32 * Vector2(direction)
	animation_timer.start(animation_time)
	await animation_timer.timeout
	var c = cell + direction
	var bubble = engine.get_bubble(c)
	if bubble and not bubble in engine.to_be_burst and not bubble.bursting:
		#print("Class: ", bubble.class_type)
		if bubble.class_type == "Projectile":
			bubble.bursting = true
			# Check if we are diagonal
			if direction.length()>1:
				bubble = engine.spawn_bubble(c, engine.BubbleType.BUBBLE)
			else:
				bubble = engine.spawn_bubble(c, engine.BubbleType.DIAGONAL)
		elif bubble.class_type == "BasicBubble":
			var size = bubble.size
			bubble.bursting = true
			# Check if we are diagonal
			if direction.length()>1:
				bubble = engine.spawn_bubble(c, engine.BubbleType.DIAGONAL)
			else:
				bubble = engine.spawn_bubble(c, engine.BubbleType.BUBBLE)
			bubble.size = size
		bubble.size += 1
	elif c in engine.area.get_used_cells():
		var new_bubble = engine.spawn_bubble(c, engine.BubbleType.PROJECTILE)
		if new_bubble:
			new_bubble.direction = direction
			new_bubble.modulate = modulate
			new_bubble.wave_dir = -wave_dir
		print("awaiting spawning")
		await new_bubble.spawn_animation
		print("spawning done")
	hide()
	print("Projectile burst done")
