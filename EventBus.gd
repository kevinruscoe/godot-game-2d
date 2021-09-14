extends Node

var player
var enemies

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	enemies = get_tree().get_nodes_in_group("enemies")

func _on_hurt_player(amount):
	player.apply_damgage(amount)
