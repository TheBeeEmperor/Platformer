extends CharacterBody2D

@onready var gunCollScale = $GunCollision.scale
@onready var gunCollPos = $GunCollision.position

@onready var dmgTimer = $"Damage Timer"
@onready var IFrames = $"IFrames"
@onready var spawnProt = $"Spawn Protection"
@onready var IFrameSprite = $"IFrame"

var SPEED : float = 300.0
var JUMP_VELOCITY : float = -400.0
var gravity : float = 1200.0
var friction : float = 1000.0
var acceralation : float = 10.0
var base_friction_divider = 2.5
var applied_acceralation : float
var friction_divider : float = base_friction_divider
var applied_friction : float

var max_health : float = Global.max_health
var health : float = max_health
var colllingEnemies : Array
var damage : float
var spwnProt : bool = true
var iframes : bool = false

var bullet : PackedScene = preload("res://src/Scenes/Objects/Bullet.tscn")

func _ready():
	Global.scene_deaths = 0

func _process(delta):
	Global.health = health
	Global.pos = position
	if Input.is_action_just_pressed("shoot"):
		spwnProt = false
	$Node2D.look_at(get_global_mouse_position())
	if $Node2D.global_rotation_degrees >= 90 || $Node2D.global_rotation_degrees <= -90:
		$Node2D2.scale.x = -1
		$GunCollision.scale.x = -gunCollScale.x
		$GunCollision.position.x = -gunCollPos.x
	else:
		$Node2D2.scale.x = 1
		$GunCollision.scale.x = gunCollScale.x
		$GunCollision.position.x = gunCollPos.x

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
			spwnProt = false
			friction_divider = base_friction_divider
			if applied_acceralation == 0:
				applied_acceralation = acceralation
			elif applied_acceralation >= acceralation and applied_acceralation != SPEED:
				applied_acceralation += acceralation
			if applied_acceralation == SPEED:
				velocity.x = direction * SPEED
			else:
				velocity.x = direction * applied_acceralation
		else:
			if applied_acceralation > 0:
				applied_acceralation = acceralation
			if is_on_floor():
				applied_friction = friction / friction_divider
				if applied_friction > 10:
					friction_divider *= 2
					velocity.x = move_toward(velocity.x,0,SPEED/applied_friction)
				else:
					friction_divider = base_friction_divider
					velocity.x = move_toward(velocity.x,0,SPEED/applied_friction)
			else:
				applied_friction = friction / friction_divider
				if applied_friction > 10:
					friction_divider *= 1.25
					velocity.x = move_toward(velocity.x,0,SPEED/applied_friction)
				else:
					friction_divider = base_friction_divider
					velocity.x = move_toward(velocity.x,0,SPEED/applied_friction)
	move_and_slide()

#Damage detection
func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		colllingEnemies.append(area.get_parent().name)
		dmgTimer.start()
		damage = 10
		_damage(damage)
	elif area.is_in_group("InstaKill"):
		_damage(health)

func _on_area_2d_area_exited(area):
	if area.is_in_group("Enemy"):
		colllingEnemies.erase(area.get_parent().name)
		if len(colllingEnemies) == 0:
			dmgTimer.stop()
			damage = 0

func _damage(dmg : float):
	if not spwnProt && not iframes:
		health -= dmg
		print("Damaged " + str(health))
		IFrames.start()
		iframes = true
		IFrameSprite.visible = true

func _on_damage_timer_timeout():
	_damage(damage)

func _on_spawn_protection_timeout():
	spwnProt = false

func _on_i_frames_timeout():
	iframes = false
	IFrameSprite.visible = false
