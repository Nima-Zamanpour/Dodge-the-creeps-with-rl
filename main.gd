extends Node

@export var mob_scene: PackedScene
var score = 0.0
var n_steps = 0
var MAX_STEPS = 100000

@onready var ai_controller = $"Player/AIController2D"

func _on_player_hit():
	game_over() # Replace with function body.
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	ai_controller.done = true
	ai_controller.reward -= 20.0
	new_game()

func new_game():
	ai_controller.needs_reset = false
	score = 0
	n_steps = 0 
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	

func _process(delta):
	n_steps +=1    
	ai_controller.reward += 0.1
	if n_steps >= MAX_STEPS:
		ai_controller.done = true
		ai_controller.needs_reset = true

	if ai_controller.needs_reset:
		ai_controller.needs_reset = false
		new_game()
		return
		
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _ready():	
	new_game()
	
func reset_if_done():
	if ai_controller.done:
		new_game()


