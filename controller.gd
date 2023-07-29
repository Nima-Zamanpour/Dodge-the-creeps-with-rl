extends AIController2D

# Stores the action sampled for the agent's policy, running in python

var move_action = Vector2.ZERO
@onready var main = $"/root/Main"
@onready var ray_sensor = $"../ray_sensor"

func get_obs() -> Dictionary:
	# get player's ray sensors
	var obs = ray_sensor.get_observation() # make 0 all to 111111111111111111111111111111111111111

	return {"obs":obs}
	

func get_reward():	# each time step the player is alive
	return 1
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		}
	
func set_action(action) -> void:	
	move_action.x =   clamp(action["move_action"][0], -1.0, 1.0)
	move_action.y =  clamp(action["move_action"][1], -1.0, 1.0)
