@tool

class_name Bubble
extends BasicBubble

@onready var projectiles = {
	$LeftProjectile: Vector2(-32, 0),
	$RightProjectile: Vector2(32, 0),
	$UpProjectile: Vector2(0, 32),
	$DownProjectile: Vector2(0, -32),
}

func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	print("Burst start at ", cell)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	for proj in projectiles:
		proj.show()
		tween.tween_property(proj, "position", proj.position + projectiles[proj], animation_time)
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
				new_bubble.modulate = modulate
				new_bubbles.append(new_bubble.spawn_animation)
	await Co.await_all(new_bubbles)
	print("Burst ended at ", cell)
