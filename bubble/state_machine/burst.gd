extends State

@onready var check_burst: Node = $"../CheckBurst"

func enter_state():
	var callables = []
	for bubble in engine.to_be_burst:
		if not bubble.bursting:
			callables.append(bubble.burst)
	print("Trigger all bursts: ", callables)
	await Co.await_all(callables)
	print("All bursts done")
	engine.state = check_burst
