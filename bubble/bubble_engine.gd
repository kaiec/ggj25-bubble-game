class_name BubbleEngine
extends Node2D

# Level Design
@export var area : TileMapLayer
@export var setup : TileMapLayer

# States
@onready var select_cell: Node = $States/SelectCell
@onready var check_burst: Node = $States/CheckBurst
@onready var burst: Node = $States/Burst
@onready var check_win: Node = $States/CheckWin
@onready var finish: Node = $States/Finish

# Instanced bubbles
@onready var bubbles: Node2D = $Bubbles


@onready var cursor: Sprite2D = $Cursor

const BUBBLE = preload("res://bubble/bubble.tscn")
const BLUE = Vector2i(3,0)

var state : State:
	set(new_state):
		if state:
			state.exit_state()
		state = new_state
		if state:
			state.enter_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_reset()
	state = select_cell
	if state:
		state.state_ready()

func get_bubble(cell):
	for bubble in bubbles.get_children():
		if cell == bubble.cell:
			return bubble

func level_reset():
	bubbles.get_children().clear()
	setup.hide()
	for cell in setup.get_used_cells():
		if setup.get_cell_atlas_coords(cell) == BLUE:
			var bubble = BUBBLE.instantiate()
			bubbles.add_child(bubble)
			bubble.cell = cell
			bubble.size = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state:
		state.state_process(delta)

func select_bubble(cell):
	var bubble = get_bubble(cell)
	if bubble:
		bubble.size += 1
	
func set_cursor(cell):
	if cell in area.get_used_cells():
		cursor.show()
		cursor.global_position = area.map_to_local(cell)
	else:
		cursor.hide()
