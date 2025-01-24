extends State

@onready var burst: Node = $"../Burst"
@onready var check_win: Node = $"../CheckWin"


func enter_state():
	engine.to_be_burst.clear()
	for bubble in engine.bubbles.get_children():
		if bubble.check_burst():
			engine.to_be_burst.append(bubble)
	if engine.to_be_burst.is_empty():
		engine.state = check_win
	else:
		engine.state = burst
