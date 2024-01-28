extends Node

var speed_ratio_default = .25
var speed_ratio_increase_per_second_default = 0.03
var time_elapsed_real_default = -11.0
var time_elapsed_virtual_default = -4.5

var speed_ratio = speed_ratio_default
var speed_ratio_increase_per_second = speed_ratio_increase_per_second_default
var time_elapsed_real = time_elapsed_real_default
var time_elapsed_virtual = time_elapsed_virtual_default
var game_started = false
var game_lost = false

@export var shared_audio_player: AudioStreamPlayer2D
