extends Actor

export var stomp_impulse: = 600.0

enum States {IDLE, WALK, DIALOGUE}
var state = States.IDLE

var can_walljump: = false

onready var wall_detector = $WallDetector

func _on_StompDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	if direction.x == -1:
		$AnimatedSprite.flip_h = true
	elif direction.x == 1:
		$AnimatedSprite.flip_h = false
	
	can_walljump = wall_detector.is_colliding()
	
	if can_walljump:
		pass
		# todo: walljump
	else:
		_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	match state:
		States.IDLE:
			if _velocity.x != 0.0:
				$AnimatedSprite.play("Walk")
				state = States.WALK
			continue
		States.WALK:
			if _velocity.x == 0.0:
				$AnimatedSprite.play("Idle")
				state = States.IDLE
			continue
	
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_pressed("jump") else 0.0
	)

func do_walljump():
	pass

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
