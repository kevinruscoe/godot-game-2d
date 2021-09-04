extends KinematicBody2D

var gravity = 1200
var run_speed = 100
var distance_allowed_to_move = 25

var start_position = Vector2()
var velocity = Vector2()
var going_right = false

func _ready():
	start_position = position

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if going_right:
		velocity.x = ((run_speed * delta) * 30)
	else:
		velocity.x = -((run_speed * delta) * 30)

	if position.x > start_position.x + distance_allowed_to_move:
		going_right = false
		
	if position.x < start_position.x - distance_allowed_to_move:
		going_right = true
		
	velocity = move_and_slide(velocity, Vector2(0, -1))
