extends Node2D

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite

@export var size: int = 1:
	set(value):
		size = value
		if label:
			label.text = str(size)

@onready var engine: BubbleEngine = $"../.."

var cell : Vector2i = Vector2i(-1, -1):
	set(new_cell):
		cell = new_cell
		position = engine.area.map_to_local(cell)
		

func _ready() -> void:
	size = size


func check_burst():
	return size > 3
	
func burst():
	print("Burst at ", cell)
	for n in [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]:
		var c = cell + n
		var bubble = engine.get_bubble(c)
		if bubble:
			bubble.size += 1
		elif c in engine.area.get_used_cells():
			engine.spawn_bubble(c)
	await get_tree().create_timer(1).timeout
	queue_free()
	print("Burst ended at ", cell)
