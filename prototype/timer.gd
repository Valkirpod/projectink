extends CanvasLayer

var elapsed := 0.0
@onready var label := $TimerLabel

func _process(delta):
	elapsed += delta
	label.text = "%.2f" % elapsed  # show 2 decimal places
