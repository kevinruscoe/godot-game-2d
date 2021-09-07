extends Node

onready var player = get_node("Actors/Player")

func _on_hurt_player():
	player.apply_damgage()
