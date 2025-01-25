@tool
class_name BasicBubble
extends Node2D

@onready var sprite: Sprite2D:
	get():
		return $Sprite

@export var size: int = 1:
	set(value):
		var old_value = size
		print("Size changed ", size, " -> ", value, " (", self, ")")
		size = value
		if sprite:
			sprite.region_rect.position.x = (size-1)*32
			if value > old_value and is_inside_tree():
				play_inflate_sound()

var bursting := false
var anim_offset := 0.0

var animation_time = 0.3

var engine: BubbleEngine:
	get():
		if Engine.is_editor_hint(): return null
		
		if !engine:
			engine = get_parent().get_parent().find_child("BubbleEngine")
			print(engine)
		return engine

var cell : Vector2i = Vector2i(-1, -1):
	set(new_cell):
		if Engine.is_editor_hint(): return
		
		cell = new_cell
		position = engine.area.map_to_local(cell)
		

func _ready() -> void:
	size = size
	if Engine.is_editor_hint(): return
	anim_offset = randf() * 100
	hide()
	spawn_animation()


func check_burst():
	if Engine.is_editor_hint(): return
	
	return size > 3

func spawn_animation():
	if Engine.is_editor_hint(): return
	
	print("Spawn animation start: ", self)
	play_inflate_sound()
	scale = Vector2(0,0)
	show()
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale", Vector2(1,1), animation_time)
	await tween.finished
	print("Spawn animation finished: ", self)
	
func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	var player = play_pop_sound()
	bursting = true
	remove_from_group("goal")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(sprite, "scale", Vector2(2,2), animation_time)
	tween.tween_property(sprite, "modulate:a", 0.5, animation_time)
	await Co.await_all([tween.finished, player.finished])
	hide()

func play_pop_sound() -> AudioStreamPlayer:
	var player : AudioStreamPlayer = $PopSounds.get_children().pick_random() as AudioStreamPlayer
	if is_in_group("goal"):
		print("Goal Pop!")
		player.pitch_scale = 0.5
		player.volume_db = 6				
	else:
		player.pitch_scale = randf_range(0.8, 1.2)
	get_tree().create_timer(randf_range(0.01, 0.05)).timeout.connect(
		func():
			player.play()
	)
	return player

func play_inflate_sound() -> AudioStreamPlayer:
	var player : AudioStreamPlayer = $SFX/Bubble1 as AudioStreamPlayer
	player.pitch_scale = randf_range(0.8, 1.2)
	get_tree().create_timer(randf_range(0.01, 0.3)).timeout.connect(
		func():
			player.play()
	)
	return player


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var pos = engine.area.map_to_local(cell)
	var time : float = float(Time.get_ticks_msec()) / 200
	position.y = pos.y + 2 * sin(time + anim_offset)
