class_name BubbleGUI
extends Node2D

signal reset_clicked


@onready var anim_offset := randf() * 100
@onready var original_pos := position


func _on_texture_button_pressed() -> void:
	reset_clicked.emit()


func _process(_delta: float) -> void:
	var time : float = float(Time.get_ticks_msec()) / 200
	position.y = original_pos.y + 2 * sin(time + anim_offset)


func set_remaining_bubbles(amount : int):
	$Label.text = str(amount)

var animation_duration = 0.1
func play_clicks_error():
	for i in range(3):
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
		tween.tween_property($Label, "modulate", Color.RED, animation_duration)
		tween.tween_property($Bubble, "modulate", Color.RED, animation_duration)
		await tween.finished
		tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
		tween.tween_property($Label, "modulate", Color.WHITE, animation_duration)
		tween.tween_property($Bubble, "modulate", Color.WHITE, animation_duration)
		await tween.finished
