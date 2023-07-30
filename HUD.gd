extends CanvasLayer

# Notifies `Main` node that the button has been pressed
#signal start_game


func update_score(score):
	$ScoreLabel.text = str(score)

	
