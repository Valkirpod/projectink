extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	
	var player_node := body
	if body.has_method("get_parent") and body.get_parent() and body.get_parent().is_in_group("player"):
		player_node = body.get_parent()
	
	if player_node.invincible:
		return
	
	get_tree().reload_current_scene()
