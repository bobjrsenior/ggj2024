extends Camera2D


@export var tile_check_every_amount_of_time = 1.8
var timer_for_tile_time = 0.0
@export var spawn_floor_every_amount_of_time = 1.0
var timer_for_spawn_floor_time = 0.0
@export var floor_fab: PackedScene
@export var floor_spike_fab: PackedScene
@export var tall_spike_fab: PackedScene
@export var timer_text: RichTextLabel
@export var player_fab: PackedScene
@export var start_text: RichTextLabel
var spawned_player = false
var last_floor: Node

	
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.speed_ratio = GlobalVariables.speed_ratio_default
	GlobalVariables.speed_ratio_increase_per_second = GlobalVariables.speed_ratio_increase_per_second_default
	GlobalVariables.time_elapsed_real = GlobalVariables.time_elapsed_real_default
	GlobalVariables.time_elapsed_virtual = GlobalVariables.time_elapsed_virtual_default
	set_timer_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVariables.game_started:
		GlobalVariables.time_elapsed_real += delta
		GlobalVariables.time_elapsed_virtual += delta * GlobalVariables.speed_ratio
		timer_for_spawn_floor_time += delta * GlobalVariables.speed_ratio
		timer_for_tile_time += delta * GlobalVariables.speed_ratio
		GlobalVariables.speed_ratio += GlobalVariables.speed_ratio_increase_per_second * delta
		set_timer_text()
		if GlobalVariables.time_elapsed_virtual >= 0 && !spawned_player:
			spawn_player()
			spawned_player = true
			
		if timer_for_spawn_floor_time > spawn_floor_every_amount_of_time:
			spawn_floor()
			timer_for_spawn_floor_time = 0.0
		
		if timer_for_tile_time > tile_check_every_amount_of_time:
			spawn_obstacle()
			timer_for_tile_time = 0.0
	
func spawn_player():
	var player_inst = player_fab.instantiate()
	player_inst.position.x = -400
	player_inst.position.y = 200 - 32
	add_child(player_inst)
	
func spawn_floor():
	var floor_inst = floor_fab.instantiate()
	floor_inst.position.x = 1000
	floor_inst.position.y = 200
	add_child(floor_inst)
	if last_floor != null:
		floor_inst.position.x = last_floor.position.x + 390
	last_floor = floor_inst
	
func spawn_obstacle():
	if GlobalVariables.time_elapsed_real > 15:
		var rand_val = randi() % 3
		if rand_val == 1:
			var floor_spike_inst = floor_spike_fab.instantiate()
			floor_spike_inst.position.x = 1000
			floor_spike_inst.position.y = 200 - 32
			add_child(floor_spike_inst)
		elif rand_val == 2:
			var tall_spike_inst = tall_spike_fab.instantiate()
			tall_spike_inst.position.x = 1000
			tall_spike_inst.position.y += 40
			add_child(tall_spike_inst)
	elif GlobalVariables.time_elapsed_real > -1:
		if randi() % 2 > 0:
			var floor_spike_inst = floor_spike_fab.instantiate()
			floor_spike_inst.position.x = 1000
			floor_spike_inst.position.y = 200 - 32
			add_child(floor_spike_inst)

func set_timer_text():
	var format_string = "%02d:%0.4f"
	var int_time = int(GlobalVariables.time_elapsed_real)
	timer_text.text = format_string % [int_time / 60, GlobalVariables.time_elapsed_real - (int_time / 60)]
	
func _input(event):
	if !GlobalVariables.game_started:
		if event.is_action_pressed("start"):
			if start_text.visible:
				start_text.visible = false
				GlobalVariables.game_started = true
			else:
				get_tree().reload_current_scene()
