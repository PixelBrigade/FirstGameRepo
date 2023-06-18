extends KinematicBody2D

enum States {GROUND, AIR}

var state = States.AIR
var velocity = Vector2(0, 0)

# var last_walljump_direction = 0
var actual_direction = 1

const SPEED = 400
const GRAVITY = 50
const JUMPFORCE = -1100


func _ready():
	pass

func _process(delta):
	match state:
		States.GROUND:
			if not is_on_floor():
				state = States.AIR
				continue
			check_move_inputs()
			if Input.is_action_pressed("jump"):
				velocity.y = JUMPFORCE
				state = States.AIR
			set_direction()
			move_and_fall()
			
		States.AIR:
			if is_on_floor():
				state = States.GROUND
				continue
			check_move_inputs()
			set_direction()
			move_and_fall()
	

func check_move_inputs():
	if Input.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		velocity.x = SPEED
	elif Input.is_action_pressed("move_left"):
		$Sprite.flip_h = true
		velocity.x = -SPEED
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)

func set_direction():
	if $Sprite.flip_h:
		actual_direction = -1
	else:
		actual_direction = 1

func move_and_fall():
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
