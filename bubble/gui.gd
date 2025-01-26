class_name BubbleGUI
extends Node2D

signal reset_clicked


func _on_texture_button_pressed() -> void:
	reset_clicked.emit()
