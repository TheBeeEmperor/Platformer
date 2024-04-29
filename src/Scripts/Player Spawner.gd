extends Node2D

@onready var Plyr : CharacterBody2D = $"../Player"

var Player : Node = preload("res://src/Scenes/Characters/Player.tscn").instantiate()

func _process(delta):
	if Global.health <= 0:
		if Global.scene_deaths == 0:
			get_parent().call_deferred("remove_child",Plyr)
		else:
			get_parent().call_deferred("remove_child",Player)
		Global.deaths += 1
		Global.scene_deaths += 1
		Player.health = Global.max_health
		Player.position = $".".global_position
		get_parent().call_deferred("add_child",Player)
		Player.health = Global.max_health
