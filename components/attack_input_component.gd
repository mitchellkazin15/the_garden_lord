class_name AttackInputComponent
extends Node

@export var attack_component : AttackComponent

func _input(event):
    attack_component.attack_dir = Input.get_axis("ui_left", "ui_right")
