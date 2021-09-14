extends KinematicBody2D

var velocity = Vector2()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var fired_right = false

func _ready():
	pass
	
func fire(is_right):
	fired_right = is_right
	
	if fired_right:
		velocity.x = 100
	else:
		velocity.x = -100

func _physics_process(delta):
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, gravity_vector)

	if is_on_floor():
		velocity.y = -150
		if fired_right:
			velocity.x = 100
		else:
			velocity.x = -100
