class_name MoveInputComponent
extends Node2D

@export var movement_component : MovementComponent

func _input(event):
    movement_component.direction = Input.get_axis("move_left", "move_right")
    movement_component.air_rotate_direction = Input.get_axis("air_rotate_ccw", "air_rotate_cw")
    movement_component.sprint_pressed = Input.is_action_pressed("sprint")
    movement_component.jump_just_pressed = Input.is_action_just_pressed("jump")
    movement_component.jump_just_released = Input.is_action_just_released("jump")
