extends Node2D

signal burst
@onready var label: Label = $Label

@export var size: int:
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
