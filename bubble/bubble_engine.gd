class_name BubbleEngine
extends Node2D

signal win
signal click(clicks_left : int)
signal false_click

# Level Design
@export var area : TileMapLayer

# States
@onready var select_cell: Node = $States/SelectCell
@onready var check_burst: Node = $States/CheckBurst
@onready var burst: Node = $States/Burst
@onready var check_win: Node = $States/CheckWin
@onready var finish: Node = $States/Finish

# Instanced bubbles
@onready var bubbles: Node2D = get_parent().find_child("Bubbles")
var to_be_burst = []


@onready var cursor: Sprite2D = $Cursor

var use_max_clicks := false
var clicks_left := 0

enum BubbleType {
	BUBBLE,
	PROJECTILE,
	DIAGONAL,
}

var type_to_bubble = {
	BubbleType.BUBBLE: preload("res://bubble/game_objects/bubble.tscn"),
	BubbleType.PROJECTILE: preload("res://bubble/projectile.tscn"),
	BubbleType.DIAGONAL: preload("res://bubble/game_objects/diagonal_bubble.tscn"),
}

var state : State:
	set(new_state):
		print("State change ", state, " -> ", new_state)
		if state:
			state.exit_state()
		state = new_state
		if state:
			state.enter_state()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_reset()
	if state:
		state.state_ready()
	finish.finished.connect(win.emit)

func get_bubble(cell):
	for bubble in bubbles.get_children():
		if cell == bubble.cell and not bubble.bursting:
			return bubble

func spawn_bubble(cell, type=BubbleType.BUBBLE) -> BasicBubble:
	var old = get_bubble(cell)
	if old:
		old.bursting = true
		print("Double bubble!")
	var bubble = type_to_bubble[type].instantiate()
	bubbles.add_child(bubble)
	bubble.cell = cell
	return bubble

func level_reset():
	bubbles.get_children().clear()
	state = select_cell


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state:
		state.state_process(delta)

func select_bubble(cell) -> bool:
	var bubble = get_bubble(cell)
	if bubble and not bubble.is_in_group("unclickable"):
		if use_max_clicks and clicks_left == 0:
			false_click.emit()
			return false
		# TODO clicks left
		bubble.size += 1
		clicks_left -= 1
		click.emit(clicks_left)
		return true
	return false
	
func set_cursor(cell):
	if cell in area.get_used_cells():
		cursor.show()
		cursor.global_position = area.map_to_local(cell)
	else:
		cursor.hide()

func set_max_clicks(max_clicks : int):
	use_max_clicks = true
	clicks_left = max_clicks
