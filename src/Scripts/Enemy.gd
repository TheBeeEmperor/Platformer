extends CharacterBody2D

@onready var main_pos : Vector2 = position

var health : float = 50.0
var SPEED : float = 150.0
var collidingFloors1 : Array
var collidingFloors2 : Array
var collidingWalls : Array
const JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

func _physics_process(delta):
	velocity.y += gravity * delta
	if len(collidingFloors1) == 0 || len(collidingFloors2) == 0 || len(collidingWalls) > 0:
		direction = -direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)

	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.is_in_group("Bullet"):
		health -= 10
		print("Hit " + str(health))
		if health <= 0:
			get_parent().call_deferred("remove_child",$".")

#Detects if Enemy requires to turn
func _on_area_2d_2_body_entered(body):
	if body.is_in_group("Obstacles"):
		collidingFloors1.append(body)
func _on_area_2d_2_body_exited(body):
	if body.is_in_group("Obstacles"):
		collidingFloors1.erase(body)
func _on_area_2d_3_body_entered(body):
	if body.is_in_group("Obstacles"):
		collidingWalls.append(body)
func _on_area_2d_3_body_exited(body):
	if body.is_in_group("Obstacles"):
		collidingWalls.erase(body)
func _on_area_2d_4_body_entered(body):
	if body.is_in_group("Obstacles"):
		collidingWalls.append(body)
func _on_area_2d_4_body_exited(body):
	if body.is_in_group("Obstacles"):
		collidingWalls.erase(body)
func _on_area_2d_5_body_entered(body):
	if body.is_in_group("Obstacles"):
		collidingFloors2.append(body)
func _on_area_2d_5_body_exited(body):
	if body.is_in_group("Obstacles"):
		collidingFloors2.erase(body)
