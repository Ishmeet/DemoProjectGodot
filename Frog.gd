extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var SPEED = 50
const JUMP_VELOCITY = -10.0
# Get the player animation object with animated sprite 2D
@onready var frog_animation = get_node("AnimatedSprite2D")
@onready var player_animation

func _ready():
	if frog_animation.animation != "Death":
		# play the idle animation
		frog_animation.play("Idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		player = get_node("../../Player/Player-CharacterBody2D")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			frog_animation.flip_h = true
		else:
			frog_animation.flip_h = false
		velocity.x = direction.x * SPEED
		
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			if frog_animation.animation != "Death":
				frog_animation.play("Jump")
	else:
		velocity.x = 0
		if frog_animation.animation != "Death":
			frog_animation.play("Idle")
		
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player-CharacterBody2D":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == "Player-CharacterBody2D":
		chase = false

func _on_death_body_entered(body):
	if body.name == "Player-CharacterBody2D":
		body.velocity.y = -200
		frog_animation.play("Death")
		await frog_animation.animation_finished
		self.queue_free()

func _on_player_damage_body_entered(body):
	if body.name == "Player-CharacterBody2D":
		body.health -= 1
		body.velocity.y = -200
		body.velocity.x = body.velocity.x * 200
		player_animation = body.get_node("AnimatedSprite2D")
		player_animation.play("Hurt")
		await player_animation.animation_finished
		
