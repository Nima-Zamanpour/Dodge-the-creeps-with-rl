extends AIController2D

# Stores the action sampled for the agent's policy, running in python

var x_action : float = 0.0

var y_action : float = 0.0

var move_action : ItemList
@onready var main = $"/root/Main"
@onready var ray_sensor = $"../ray_sensor"

func get_obs() -> Dictionary:
	# get player's ray sensors
	var obs = ray_sensor.get_observation()

	return {"obs":obs}
	

func get_reward():	
	return main.score
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		}
	
func set_action(action) -> void:	
	move_action = clamp(action["move_action"][0], -1.0, 1.0)
