extends KinematicBody2D

var timer = 0
var health = 100

var velocity = Vector2()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var move_speed = 100
var jump_force = 400

var is_jumping = false
var is_input_frozen = false

var is_pressing_left = false
var is_pressing_right = false
var is_pressing_up = false
var is_pressing_fire = false

onready var sprite = get_node("AnimatedSprite")
onready var raycast_up = get_node("RayCasts/UpRayCast2D")
onready var raycast_left = get_node("RayCasts/LeftRayCast2D")
onready var raycast_right = get_node("RayCasts/RightRayCast2D")
onready var camera = get_node("Camera2D")
onready var ui_container = camera.get_node("MarginContainer")
onready var time_label = ui_container.get_node("Time");
onready var health_label = ui_container.get_node("Health");

func _enter_tree():
	add_to_group("player")

func handle_movement():

	velocity.x = 0

	if is_pressing_up and is_on_floor():
		velocity.y = -jump_force
		is_jumping = true

	if is_pressing_right:
		sprite.set_scale(Vector2(-1, 1))
		velocity.x += move_speed

	if is_pressing_left:
		sprite.set_scale(Vector2(1, 1))
		velocity.x -= move_speed


func handle_animations():

	if is_pressing_right:
		sprite.set_scale(Vector2(-1, 1))
	if is_pressing_left:
		sprite.set_scale(Vector2(1, 1))

	if ! is_on_floor():
		sprite.play("Jumping")
	else:	
		if is_pressing_left || is_pressing_right:
			sprite.play("Walking")
		else:
			sprite.play("Idle")


func handle_input():

	is_pressing_right = Input.is_action_pressed('ui_right')
	is_pressing_left = Input.is_action_pressed('ui_left')
	is_pressing_up = Input.is_action_just_pressed('ui_up')
	is_pressing_fire = Input.is_action_just_pressed('ui_select')


func handle_collisions():

	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)

		if collision.collider is TileMap:
			handle_tilemap_collision(collision)


func handle_tilemap_collision(collision):
	
	# Find the tile we've collided with
	var tile_pos = collision.collider.world_to_map(collision.position - collision.normal)
	var tile_name = collision.collider.tile_set.tile_get_name(collision.collider.get_cellv(tile_pos))
			
	# hitting blocks from below
	if is_jumping && raycast_up.get_collider():
		if tile_name == "pickup":
			collision.collider.set_cellv(tile_pos, collision.collider.tile_set.find_tile_by_name("pickup_used"))

func handle_timer(delta):
	timer += delta

	time_label.text = str( int(timer) )

func handle_fire():
	if is_pressing_fire:
		var bullet = load("res://Bullet.tscn").instance()
		bullet.position = position

		add_child(bullet)

func _physics_process(delta):

	print(position)

	handle_timer(delta)
	
	if not is_input_frozen:
		handle_input()
		handle_movement()
		handle_animations()
		handle_fire()
		
	handle_collisions()

	# update gravity
	velocity.y += gravity * delta

	# move
	velocity = move_and_slide(velocity, gravity_vector)

	# toggle jump
	if is_on_floor() && is_jumping:
		is_jumping = false


func apply_damgage(damage):

	health -= damage

	health_label.text = str( int(health) )

	if (health <= 0):
		print("ded")

	sprite.set_modulate(Color8(255, 0, 0, 45))
		
	is_input_frozen = true
	
	velocity.y = -300
	velocity.x = -200
	
	yield(get_tree().create_timer(0.4), "timeout")
	
	is_input_frozen = false
	
	sprite.set_modulate(Color8(255, 255, 255, 255))
