@tool

class_name Bubble
extends BasicBubble

var directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@onready var projectiles : Dictionary

func _ready() -> void:
	class_type = "Bubble"
	projectiles = {
		$LeftProjectile: Vector2(directions[0] * 32),
		$RightProjectile: Vector2(directions[1] * 32),
		$UpProjectile: Vector2(directions[2] * 32),
		$DownProjectile: Vector2(directions[3] * 32),
	}
	super()
	
	
func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	#print("Burst start at ", cell)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	for proj in projectiles:
		proj.show()
		tween.tween_property(proj, "position", proj.position + projectiles[proj], animation_time)
	print("Waiting for super class burst")
	await super()
	print("Super done")
	var new_bubbles = []
	for n in directions:
		var c = cell + n
		var bubble = engine.get_bubble(c)
		if bubble  and not bubble in engine.to_be_burst:
			print("Class: ", bubble.class_type)
			if bubble.class_type == "Projectile":
				bubble.bursting = true
				# Check if we are diagonal
				if n.length()>1:
					bubble = engine.spawn_bubble(c, engine.BubbleType.BUBBLE)
				else:
					bubble = engine.spawn_bubble(c, engine.BubbleType.DIAGONAL)			
			elif bubble.class_type == "BasicBubble":
				var size = bubble.size
				bubble.bursting = true
				# Check if we are diagonal
				if n.length()>1:
					bubble = engine.spawn_bubble(c, engine.BubbleType.DIAGONAL)
				else:
					bubble = engine.spawn_bubble(c, engine.BubbleType.BUBBLE)			
				bubble.size = size
			bubble.size += 1
		elif c in engine.area.get_used_cells():
			var new_bubble = engine.spawn_bubble(c, engine.BubbleType.PROJECTILE)
			if new_bubble:
				new_bubble.direction = n
				new_bubble.modulate = modulate
				new_bubbles.append(new_bubble.spawn_animation)
	print("Waiting for new bubbles to spawn")
	await Co.await_all(new_bubbles)
	print("Done")
	#print("Burst ended at ", cell)
