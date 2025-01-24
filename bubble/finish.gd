extends State

signal finished

func enter_state():
	finished.emit()
