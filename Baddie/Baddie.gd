extends KinematicBody2D

var velocity = Vector2()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var move_speed = 50
var distance_allowed_to_move = 25

var start_position = Vector2()

var going_right = false

onready var sprite = get_node("AnimatedSprite")
onready var raycast_up = get_node("RayCasts/UpRayCast2D")
onready var raycast_left = get_node("RayCasts/LeftRayCast2D")
onready var raycast_right = get_node("RayCasts/RightRayCast2D")

signal hurt_player

func _enter_tree():
	add_to_group("enemies")

func _ready():
	start_position = position
	
	setup_events()
	
func setup_events():
	connect("hurt_player", get_node('/root/Node'), "_on_hurt_player")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if going_right:
		velocity.x = move_speed
		sprite.set_scale(Vector2(-1, 1))
	else:
		velocity.x = -move_speed
		sprite.set_scale(Vector2(1, 1))

	sprite.play("Walking")

	if position.x > start_position.x + distance_allowed_to_move:
		going_right = false
		
	if position.x < start_position.x - distance_allowed_to_move:
		going_right = true
		
	for raycast in get_node("RayCasts").get_children():
		if raycast.get_collider():
			if raycast.get_collider().is_in_group("player"):
				emit_signal("hurt_player", 5)
		
	velocity = move_and_slide(velocity, gravity_vector)
