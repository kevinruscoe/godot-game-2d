extends KinematicBody2D

var gravity = 1200
var run_speed = 100
var distance_allowed_to_move = 25

var start_position = Vector2()
var velocity = Vector2()
var going_right = false

onready var raycast_up = get_node("RayCasts/UpRayCast2D")
onready var raycast_left = get_node("RayCasts/LeftRayCast2D")
onready var raycast_right = get_node("RayCasts/RightRayCast2D")

signal hurt_player

func _ready():
	start_position = position
	connect("hurt_player", self, "_on_hurt_player")

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

	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		
		if collision.collider is KinematicBody2D:
			# TODO: work out if its actually the player
			emit_signal("hurt_player")
		
	velocity = move_and_slide(velocity, Vector2(0, -1))

funct _on_hurt_player():
	# get Player node, hurt it
	pass