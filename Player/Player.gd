extends KinematicBody2D

var run_speed = 100
var jump_speed = 400
var gravity = 1200

var velocity = Vector2()

var timer = 0

var is_jumping = false
var pressing_left = false
var pressing_right = false
var pressed_space = false

onready var sprite = get_node("AnimatedSprite")
onready var up_raycast = get_node("UpRayCast2D")
onready var camera = get_node("Camera2D")
onready var time_label = camera.get_node("Time");

func handle_movement():

	velocity.x = 0

	if pressed_space and is_on_floor():
		velocity.y = -jump_speed
		is_jumping = true

	if pressing_right:
		sprite.set_scale(Vector2(-1, 1))
		velocity.x += run_speed

	if pressing_left:
		sprite.set_scale(Vector2(1, 1))
		velocity.x -= run_speed


func handle_animations():

	if pressing_right:
		sprite.set_scale(Vector2(-1, 1))
	if pressing_left:
		sprite.set_scale(Vector2(1, 1))

	if ! is_on_floor():
		sprite.play("Jumping")
	else:	
		if pressing_left || pressing_right:
			sprite.play("Walking")
		else:
			sprite.play("Idle")


func handle_input():

	pressing_right = Input.is_action_pressed('ui_right')
	pressing_left = Input.is_action_pressed('ui_left')
	pressed_space = Input.is_action_just_pressed('ui_select')


func handle_collisions():

	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		
		if collision.collider is KinematicBody2D:
			handle_enemy_collision(collision)

		if collision.collider is TileMap:
			handle_tilemap_collision(collision)


func handle_enemy_collision(_collision):
	sprite.set_modulate(Color8(255, 0, 0, 45))


func handle_tilemap_collision(collision):
	
	# Find the tile we've collided with
	var tile_pos = collision.collider.world_to_map(collision.position - collision.normal)
	var tile_name = collision.collider.tile_set.tile_get_name(collision.collider.get_cellv(tile_pos))
		
	# hitting blocks from below
	if is_jumping && up_raycast.get_collider():
		if tile_name == "pickup":
			collision.collider.set_cellv(tile_pos, collision.collider.tile_set.find_tile_by_name("pickup_used"))


func _physics_process(delta):

	timer += delta

	time_label.text = str( int(timer) )

	handle_input()
	handle_movement()
	handle_animations()
	handle_collisions()

	# update gravity
	velocity.y += gravity * delta

	# move
	velocity = move_and_slide(velocity, Vector2(0, -1))

	# toggle jump
	if is_on_floor() && is_jumping:
		is_jumping = false
