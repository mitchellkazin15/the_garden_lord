class_name AttackInputComponent
extends Node

@export var attack_component : AttackComponent

func _input(event):
    attack_component.attack_dir = round(Input.get_axis("attack_left", "attack_right"))
