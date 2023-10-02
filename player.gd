extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Get the player animation object with animated sprite 2D
@onready var player_animation = get_node("AnimatedSprite2D")

func _ready():
	# play the idle animation
	player_animation.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		player_animation.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		player_animation.flip_h = true
	elif direction == 1:
		player_animation.flip_h = false

	# Get the input down and up direction and handle the movement/deceleration.
	var crouch = Input.get_axis("ui_down", "ui_up")
	if crouch == -1:
		player_animation.play("Crouch")
		velocity.x = (direction * SPEED)/2
	
	if crouch == 0:
		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				player_animation.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				player_animation.play("Idle")

	if velocity.y > 0:
		player_animation.play("Fall")
	
	move_and_slide()
