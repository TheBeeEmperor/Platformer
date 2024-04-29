extends Node2D

@onready var Player = $"Player"
@onready var Camera = $Camera
@onready var CameraBounds : Array = [$"Camera Bound 1".position.x,$"Camera Bound 2".position.x,$"Camera Bound 3".position.y]

# Called when the node enters the scene tree for the first time.
func _ready():
	Camera.limit_left = CameraBounds[0]
	Camera.limit_right = CameraBounds[1]
	Camera.limit_bottom = CameraBounds[2]

func _process(delta):
	Camera.position = Global.pos
