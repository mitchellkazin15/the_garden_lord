class_name WanderState
extends State

@export var enemy : CharacterBody2D
@export var movement_component : MovementComponent
@export var close_state : State
@export var far_state : State
@export var max_wander_distance : float
@export var min_wander_distance : float
var player : Player
var wander_time = 0.0
var time_elapsed = 0.0


func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    if is_instance_valid(player):
        var distance_vector = player.global_position - enemy.global_position
        if distance_vector.length() <= min_wander_distance:
            transitioned.emit(self, close_state.name)
            return
        elif distance_vector.length() >= max_wander_distance:
            transitioned.emit(self, far_state.name)
            return
    time_elapsed += delta
    if time_elapsed >= wander_time:
        movement_component.direction = randi_range(-1, 1)
        wander_time = randf_range(0, 4)
        time_elapsed = 0


func exit():
    movement_component.direction = 0
