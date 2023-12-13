extends CharacterBody2D

@onready var main_pos : Vector2 = position
@onready var Player : CharacterBody2D = $"../Player"

@export var offset : float = 100
@export var SPEED : float = 150.0
const JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

func _process(delta):
	get_node("RayCast2D").look_at(Player.position)

func _physics_process(delta):
	velocity.y += gravity * delta
	if position.x <= main_pos.x - offset and direction == -1:
		direction = 1
	elif position.x >= main_pos.x + offset and direction == 1:
		direction = -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)

	move_and_slide()
