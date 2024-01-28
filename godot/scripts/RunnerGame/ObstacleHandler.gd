extends Node2D
@export var speed = 400 # How fast the player will move (pixels/sec).

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVariables.game_started:
		position.x -= speed * delta * GlobalVariables.speed_ratio
		if position.x < -2000:
			queue_free()
