extends Node2D

@export var rotation_degrees_per_second = 180
var degrees_to_rads = 0.01745329

@export var jump_height = 100
@export var jump_duration = 1.35
@export var crouch_duration = 1.35
@export var character_sprite: Sprite2D
@export var neutral_sprite: Resource
@export var happy_sprite: Resource
@export var sad_sprite: Resource
@export var surprised_sprite: Resource
@export var happy_audio: AudioStreamOggVorbis
@export var sad_audio: AudioStreamOggVorbis
@export var surprised_audio: AudioStreamOggVorbis
var audio_player: AudioStreamPlayer2D
var audio_bus_index = AudioServer.get_bus_index("sfx")
var pitch_effect = AudioServer.get_bus_effect(audio_bus_index, 0)
var default_y_value: float
var jump_start_time: float
var crouch_end_time: float
var mid_jump = false
var mid_crouch = false
var mid_action = false

# Called when the node enters the scene tree for the first time.
func _ready():
	default_y_value = position.y
	character_sprite.texture = neutral_sprite
	audio_player = GlobalVariables.shared_audio_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rotation_degrees_per_second * delta * degrees_to_rads
	if mid_jump:
		var time_dif = (GlobalVariables.time_elapsed_virtual - jump_start_time)
		if (time_dif >= jump_duration):
			position.y = default_y_value
			character_sprite.texture = neutral_sprite
			audio_player.stop()
			mid_jump = false
			mid_action = false
		else:
			position.y = default_y_value - (jump_height * sin((time_dif / jump_duration) * 3.1415926535))
	elif mid_crouch:
		if GlobalVariables.time_elapsed_virtual > crouch_end_time:
			character_sprite.texture = neutral_sprite
			scale.x = 1
			scale.y = 1
			position.y -= 8
			audio_player.stop()
			mid_crouch = false
			mid_action = false
	
func _input(event):
	if !mid_jump && !mid_action && event.is_action_pressed("jump"):
		mid_action = true
		jump_start_time = GlobalVariables.time_elapsed_virtual
		character_sprite.texture = happy_sprite
		audio_player.stream = happy_audio
		var playback_scale = 1 + (GlobalVariables.speed_ratio - GlobalVariables.speed_ratio_default)
		audio_player.pitch_scale = playback_scale
		pitch_effect.pitch_scale = 1 / playback_scale
		audio_player.play()
		mid_jump = true
	elif !mid_crouch && !mid_action && event.is_action_pressed("crouch"):
		mid_action = true
		crouch_end_time = GlobalVariables.time_elapsed_virtual + crouch_duration
		scale.x = 0.5
		scale.y = 0.5
		position.y += 8
		character_sprite.texture = surprised_sprite
		audio_player.stream = surprised_audio
		var playback_scale = 1 + (GlobalVariables.speed_ratio - GlobalVariables.speed_ratio_default)
		audio_player.pitch_scale = playback_scale
		pitch_effect.pitch_scale = 1 / playback_scale
		audio_player.play()
		mid_crouch = true
		


func _on_area_2d_area_entered(area):
	print("You Lose")
	GlobalVariables.game_started = false
	GlobalVariables.game_lost = true
	queue_free()
