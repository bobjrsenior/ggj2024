extends Area2D


func _on_area_entered(area):
	print("You Lose")
	queue_free()
