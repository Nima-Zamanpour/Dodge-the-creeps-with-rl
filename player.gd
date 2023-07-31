extends Area2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
signal hit
@onready var ai_controller = $AIController2D

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	ai_controller.init(self)

func _process(delta):
	pass

	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _physics_process(delta):
	
	if ai_controller.needs_reset:
		ai_controller.reset()
		return
	
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if ai_controller.heuristic == "human":
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	else:
		velocity = ai_controller.move_action
		
	if velocity.length() > 0:
		if velocity.length() > 1:
			velocity = velocity.normalized() * speed
		else:
			velocity = velocity * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# animation
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	# Check if the node's position is outside the viewport
	var viewport_rect = get_viewport_rect()
	var temp_position = self.global_position
	
	####   game over is player hits edge of window  ####
	if temp_position.x <= 0 or temp_position.x >= viewport_rect.size.x or temp_position.y <= 0 or temp_position.y >= viewport_rect.size.y:
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", false)


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", false)
