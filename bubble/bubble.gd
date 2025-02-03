@tool

class_name Bubble
extends BasicBubble

var directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@onready var projectiles : Dictionary

func _ready() -> void:
	class_type = "Bubble"
	super()
	
	
func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	#print("Burst start at ", cell)
	print("Waiting for super class burst")
	super()
	print("Super done")
	var projectile_spawns = []
	var projectile_bursts = []
	for dir in directions:
		var proj = engine.spawn_bubble(cell, engine.BubbleType.PROJECTILE)
		if proj:
			proj.bursting = false
			proj.direction = dir
			proj.modulate = modulate
			projectile_spawns.append(proj.spawn_animation)
			projectile_bursts.append(proj.burst)
	await Co.await_all(projectile_spawns)
	await Co.await_all(projectile_bursts)
	print("Done")
	#print("Burst ended at ", cell)
