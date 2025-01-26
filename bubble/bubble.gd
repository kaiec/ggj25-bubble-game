@tool

class_name Bubble
extends BasicBubble

var directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@onready var projectiles : Dictionary

func _ready() -> void:
	projectiles = {
		$LeftProjectile: Vector2(directions[0] * 32),
		$RightProjectile: Vector2(directions[1] * 32),
		$UpProjectile: Vector2(directions[2] * 32),
		$DownProjectile: Vector2(directions[3] * 32),
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
	for n in directions:
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
