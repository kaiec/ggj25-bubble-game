extends State

@onready var finish: Node = $"../Finish"
@onready var select_cell: Node = $"../SelectCell"


func enter_state():
	# Win Condition: No more goal bubbles
	# TODO: What about lost games?
	print(get_tree().get_nodes_in_group("goal"))
	if get_tree().get_nodes_in_group("goal").is_empty():
		engine.state = finish
		return
	engine.state = select_cell
