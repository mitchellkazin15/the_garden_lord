class_name FollowState
extends State

@export var enemy : CharacterBody2D
@export var movement_component : MovementComponent
@export var max_follow_distance : float
@export var max_attack_distance : float
var player : Player


func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    var distance_vector = player.global_position - enemy.global_position 
    if distance_vector.length() > max_follow_distance:
        transitioned.emit(self, "WanderState")
        return
    if distance_vector.length() <= max_attack_distance:
        transitioned.emit(self, "MeleeAttackState")
        return
    movement_component.direction = sign(distance_vector.x)


func exit():
    movement_component.direction = 0
