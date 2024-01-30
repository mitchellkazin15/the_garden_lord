class_name IdleState
extends State

@export var enemy : CharacterBody2D
@export var next_state : State
@export var max_idle_distance : float
var player : Player


func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    if is_instance_valid(player):
        var distance_vector = player.global_position - enemy.global_position
        if distance_vector.length() <= max_idle_distance:
            transitioned.emit(self, next_state.name)
            return


func exit():
    pass
