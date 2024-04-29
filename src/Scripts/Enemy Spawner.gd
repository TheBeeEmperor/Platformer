extends Node2D

@export var health : float = 50.0
@export var SPEED : float = 150.0
var Enemy : Node = preload("res://src/Scenes/Characters/Enemy.tscn").instantiate()

func _ready():
	Enemy.SPEED = SPEED
	Enemy.health = health
	Enemy.position = $".".global_position
	get_parent().call_deferred("add_child",Enemy)

func _process(delta):
	if Global.health <= 0:
		get_parent().call_deferred("remove_child",Enemy)
		Enemy.SPEED = SPEED
		Enemy.health = health
		Enemy.position = $".".global_position
		get_parent().call_deferred("add_child",Enemy)
