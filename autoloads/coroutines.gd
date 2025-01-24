# Source: https://luiscarli.com/2023/10/06/await-all/
# This needs to be added as an auto-load (I used the global name `Co`)
class_name Coroutines
extends Node

func await_all(list: Array):
	var counter = {
		value = list.size()
	}
	
	for el in list:
		if el is Signal:
			el.connect(count_down.bind(counter), CONNECT_ONE_SHOT)
		elif el is Callable:
			func_wrapper(el, count_down.bind(counter))
	
	while counter.value > 0:
		await get_tree().process_frame


func count_down(dict):
	dict.value -= 1


@warning_ignore("shadowed_variable_base_class")
func func_wrapper(call: Callable, call_back: Callable):
	await call.call()
	call_back.call()
