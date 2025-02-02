class_name Projectile
extends BasicBubble

var direction := Vector2i(1, 0)

func _ready() -> void:
	super()
	class_type = "Projectile"

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
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + 32*Vector2(direction), 0.3)
	print("awaiting tween")
	await tween.finished
	print("tween done")
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
		print("awaiting spawning")
		await new_bubble.spawn_animation
		print("spawning done")
	hide()
	print("Projectile burst done")
