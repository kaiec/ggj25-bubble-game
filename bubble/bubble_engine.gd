class_name BubbleEngine
extends Node2D

@export var area : TileMapLayer
@export var setup : TileMapLayer

@onready var select_cell: Node = $States/SelectCell


var state : State:
	set(new_state):
		if state:
			state.exit_state()
		state = new_state
		if state:
			state.enter_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = select_cell
	if state:
		state.state_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state:
		state.state_process(delta)

func set_cursor(cell):
	$Sprite2D.global_position = area.map_to_local(cell)
