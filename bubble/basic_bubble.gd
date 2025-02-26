@tool
class_name BasicBubble
extends Node2D

@export var class_type = "BasicBubble"

const SPRITESHEET_1 = preload("res://bubble/assets/atom/render/spritesheet-1.png")
const SPRITESHEET_2 = preload("res://bubble/assets/atom/render/spritesheet-2.png")
const SPRITESHEET_3 = preload("res://bubble/assets/atom/render/spritesheet-3.png")

const spritesheets = [SPRITESHEET_1, SPRITESHEET_2, SPRITESHEET_3]
@onready var animation_player: AnimationPlayer = $Sprite/AnimationPlayer

@onready var sprite: Sprite2D:
	get():
		return $Sprite

@export var size: int = 1:
	set(value):
		var old_value = size
		#print("Size changed ", size, " -> ", value, " (", self, ")")
		size = value
		_update_sprite(old_value)

var bursting := false
var anim_offset := 0.0

var animation_time = 0.6

var engine: BubbleEngine:
	get():
		if Engine.is_editor_hint(): return null
		
		if !engine:
			engine = get_parent().get_parent().find_child("BubbleEngine")
			#print(engine)
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
	animation_player.seek(randf_range(0, 3))
	hide()
	spawn_animation()


func check_burst():
	if Engine.is_editor_hint(): return
	
	return size > 3

func spawn_animation():
	if Engine.is_editor_hint(): return
	
	#print("Spawn animation start: ", self)
	play_inflate_sound()
	scale = Vector2(0,0)
	show()
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "scale", Vector2(1,1), animation_time)
	await tween.finished
	#print("Spawn animation finished: ", self)
	
func burst():
	if Engine.is_editor_hint(): return
	
	if bursting:
		return
	bursting = true
	remove_from_group("goal")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(sprite, "scale", Vector2(2,2), animation_time)
	tween.tween_property(sprite, "modulate:a", 0.5, animation_time)
	await Co.await_all([tween.finished, play_pop_sound])
	hide()


func _update_sprite(old_size):
	if sprite:
		sprite.texture = spritesheets[min(size, len(spritesheets)) - 1]
		if size > old_size and is_inside_tree():
			play_inflate_sound()


func play_pop_sound() -> void:
	var player : AudioStreamPlayer = $PopSounds.get_children().pick_random() as AudioStreamPlayer
	if is_in_group("goal"):
		print("Goal Pop!")
		player.pitch_scale = 0.5
		player.volume_db = 6
	else:
		player.pitch_scale = randf_range(0.8, 1.2)
	await get_tree().create_timer(randf_range(0.01, 0.05)).timeout
	player.play()
	await player.finished


func play_inflate_sound() -> AudioStreamPlayer:
	if Engine.is_editor_hint(): return
	
	var player : AudioStreamPlayer = $SFX/Bubble1 as AudioStreamPlayer
	player.pitch_scale = randf_range(0.8, 1.2)
	get_tree().create_timer(randf_range(0.01, 0.3)).timeout.connect(
		func():
			if player:
				player.play()
	)
	return player


func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var pos = engine.area.map_to_local(cell)
	var time : float = float(Time.get_ticks_msec()) / 200
	position.y = pos.y + 2 * sin(time + anim_offset)
