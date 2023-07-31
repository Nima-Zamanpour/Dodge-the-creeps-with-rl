extends Node

@export var mob_scene: PackedScene
var score = 0.

@onready var ai_controller = $"Player/AIController2D"

func _on_player_hit():
	game_over() # Replace with function body.
"func _on_player_hit_edge():
	game_over()"
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	ai_controller.reward = -10
	ai_controller.done = true
	ai_controller.needs_reset = true
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	
func _on_score_timer_timeout():
	ai_controller.reward += 1
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
	var velocity = Vector2(randf_range(50.0, 150.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _ready():
	new_game()


