extends CharacterBody2D

@onready var end_point = $"../Player/Node2D2/Gun/End Point"
@onready var pos = end_point.global_position

func _ready():
	velocity = (pos - position)*2
	
func _physics_process(delta):
	move_and_slide()

func _on_area_2d_body_entered(body):
	get_parent().call_deferred("remove_child",$".")


func _on_timer_timeout():
	get_parent().call_deferred("remove_child",$".")
