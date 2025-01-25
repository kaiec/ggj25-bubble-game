extends BasicBubble

var direction := Vector2i(1, 0)

func check_burst():
	return true

func spawn_animation():
	if Engine.is_editor_hint(): return # TODO not sure if needed
	
	print("Spawn animation start: ", self)
	show()
	print("Spawn animation finished: ", self)
	

func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	bursting = true
	remove_from_group("goal")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position", position + 32*Vector2(direction), 0.3)
	await tween.finished
	var c = cell + direction
	var bubble = engine.get_bubble(c)
	if bubble:
		bubble.size += 1
	elif c in engine.area.get_used_cells():
		var new_bubble = engine.spawn_bubble(c, engine.BubbleType.PROJECTILE)
		if new_bubble:
			new_bubble.direction = direction
		await new_bubble.spawn_animation
	hide()

func _process(delta: float) -> void:
	pass
