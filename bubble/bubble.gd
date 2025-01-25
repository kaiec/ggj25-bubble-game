@tool

class_name Bubble
extends BasicBubble

func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	print("Burst start at ", cell)
	await super()
	var new_bubbles = []
	for n in [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]:
		var c = cell + n
		var bubble = engine.get_bubble(c)
		if bubble:
			bubble.size += 1
		elif c in engine.area.get_used_cells():
			var new_bubble = engine.spawn_bubble(c, engine.BubbleType.PROJECTILE)
			if new_bubble:
				new_bubble.direction = n
				new_bubbles.append(new_bubble.spawn_animation)
	await Co.await_all(new_bubbles)
	print("Burst ended at ", cell)
