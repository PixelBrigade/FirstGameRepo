extends Actor

onready var stomp_area: Area2D = $StompArea2D
onready var floor_detector = $FloorDetector

export var score: = 100

func _ready() -> void:
	speed = Vector2(200.0, 500.0)
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	if (is_on_wall()) or (not floor_detector.is_colliding()):
		floor_detector.position.x *= -1
		_velocity.x *= -1
	else:
		floor_detector.position.x *= 1
		_velocity.x *= 1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
	die()

func die() -> void:
	PlayerData.score += score
	queue_free()
