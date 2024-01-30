class_name FollowState
extends State

@export var enemy : CharacterBody2D
@export var movement_component : MovementComponent
@export var close_state : State
@export var far_state : State
@export var max_follow_distance : float
@export var min_follow_distance : float
var player : Player


func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    if not is_instance_valid(player):
        transitioned.emit(self, far_state.name)
        return
    var distance_vector = player.global_position - enemy.global_position 
    if distance_vector.length() > max_follow_distance:
        transitioned.emit(self, far_state.name)
        return
    if distance_vector.length() <= min_follow_distance:
        transitioned.emit(self, close_state.name)
        return
    movement_component.direction = sign(distance_vector.x)


func exit():
    movement_component.direction = 0
