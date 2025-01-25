@tool
class_name BasicBubble
extends Node2D

@onready var label: Label = $Label:
	get():
		return $Label

@onready var sprite: Sprite2D = $Sprite

@export var size: int = 1:
	set(value):
		print("Size changed ", size, " -> ", value, " (", self, ")")
		size = value
		if label:
			label.text = str(size)

var bursting := false
var anim_offset := 0.0

var engine: BubbleEngine:
	get():
		if Engine.is_editor_hint(): return null
		
		if !engine:
			engine = get_parent().get_parent().find_child("BubbleEngine")
			print(engine)
		return engine

var cell : Vector2i = Vector2i(-1, -1):
	set(new_cell):
		if Engine.is_editor_hint(): return
		
		cell = new_cell
		position = engine.area.map_to_local(cell)
		

func _ready() -> void:
	size = size
	if Engine.is_editor_hint(): return
	anim_offset = randf() * 100
	hide()
	spawn_animation()


func check_burst():
	if Engine.is_editor_hint(): return
	
	return size > 3

func spawn_animation():
	if Engine.is_editor_hint(): return
	
	print("Spawn animation start: ", self)
	scale = Vector2(0,0)
	show()
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale", Vector2(1,1), 0.4)
	await tween.finished
	print("Spawn animation finished: ", self)
	
func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	bursting = true
	remove_from_group("goal")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "scale", Vector2(2,2), 0.3)
	tween.tween_property(self, "modulate:a", 0.5, 0.3)
	await tween.finished
	hide()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var pos = engine.area.map_to_local(cell)
	var time : float = float(Time.get_ticks_msec()) / 200
	position.y = pos.y + 2 * sin(time + anim_offset)
