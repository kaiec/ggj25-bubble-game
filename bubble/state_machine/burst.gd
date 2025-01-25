extends State

@onready var check_burst: Node = $"../CheckBurst"

func enter_state():
	var callables = []
	for bubble in engine.to_be_burst:
		callables.append(bubble.burst)
	print("Trigger all bursts")
	await Co.await_all(callables)
	print("All bursts done")
	engine.state = check_burst
