class_name DashComponent
extends Node2D

@export var movement_component : MovementComponent

func _input(_event):
    if Input.is_action_just_released("dash"):
        var direction = movement_component.get_facing_direction()
        print(direction)
        movement_component.apply_impulse(direction * 400)
    pass
