extends CharacterBody2D

@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -400.0
@export var gravity : float = 1200.0
var max_health : float = Global.max_health
var health : float = Global.health

func _process(delta):
	Global.health = health

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if is_on_floor() or velocity.x == 0:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x,0,SPEED)
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		var rotation1 = area.get_parent().get_node("PlayerPos").rotation
		var direction
		if rotation1 <= 4.5 and rotation1 >= 0:
			direction = -1
		elif rotation1 > 4.5 or rotation1 < 7.5:
			direction = 1
		_damage(10, direction)
		print("Damaged " + str(health))
	elif area.is_in_group("InstaKill"):
		_damage(health,0)
	

func _damage(dmg : float,direction : int):
	health -= dmg
	if health <= 0:
		health = max_health
		position.x = 0
		position.y = 0
		velocity.x = 0
		velocity.y = 0
	else:
		_damage_bounce(direction)

func _damage_bounce(direction : int):
	velocity.y = JUMP_VELOCITY/1.5
	velocity.x = direction * SPEED
	move_and_slide()
		
