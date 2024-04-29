extends Node2D

var bullet : PackedScene = preload("res://src/Scenes/Objects/Bullet.tscn")
var shot_bullet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		if get_parent().get_parent().is_on_floor():
			shoot()

func shoot():
	shot_bullet = bullet.instantiate()
	shot_bullet.position = $Node2D.global_position
	get_parent().get_parent().get_parent().add_child(shot_bullet)
