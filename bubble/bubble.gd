class_name Bubble
extends Node2D

@onready var label: Label = $Label
@onready var sprite: Sprite2D = $Sprite

@export var size: int = 1:
	set(value):
		print("Size changed ", size, " -> ", value, " (", self, ")")
		size = value
		if label:
			label.text = str(size)

var bursting := false

@onready var engine: BubbleEngine = $"../.."

var cell : Vector2i = Vector2i(-1, -1):
	set(new_cell):
		cell = new_cell
		position = engine.area.map_to_local(cell)
		

func _ready() -> void:
	size = size
	hide()


func check_burst():
	return size > 3

func spawn_animation():
	print("Spawn animation start: ", self)
	scale = Vector2(0,0)
	show()
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale", Vector2(1,1), 1)
	await tween.finished
	print("Spawn animation finished: ", self)
	
func burst():
	if bursting:
		return
	bursting = true
	print("Burst at ", cell)
	var new_bubbles = []
	for n in [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]:
		var c = cell + n
		var bubble = engine.get_bubble(c)
		if bubble:
			bubble.size += 1
		elif c in engine.area.get_used_cells():
			var new_bubble = engine.spawn_bubble(c)
			if new_bubble:
				new_bubbles.append(new_bubble.spawn_animation)
	await Co.await_all(new_bubbles)
	print("Burst ended at ", cell)

func _process(_delta: float) -> void:
	var pos = engine.area.map_to_local(cell)
	var time : float = float(Time.get_ticks_msec()) / 200
	position.y = pos.y + 2 * sin(time)
