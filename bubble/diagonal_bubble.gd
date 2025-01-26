@tool

extends Bubble



func _ready() -> void:
	directions = [Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(1,1)]
	super()
	class_type = "Diagonal"
