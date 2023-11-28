class_name FollowState
extends State

@export var enemy : CharacterBody2D
@export var movement_component : MovementComponent
@export var max_follow_distance : float
var player : Player

func enter():
    player = get_tree().get_first_node_in_group("Player")

func physics_update(delta):
    var distance_vector = enemy.global_position - player.global_position
    if distance_vector.length() > max_follow_distance:
        transitioned.emit(self, "WanderState")
        return
    movement_component.direction = sign(-1 *    distance_vector.x)
    
