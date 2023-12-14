extends Sprite2D

@export var Scene : String

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		get_tree().change_scene_to_file(Scene)
