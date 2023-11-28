class_name WanderState
extends State

@export var enemy : CharacterBody2D
@export var movement_component : MovementComponent
var player : Player

@export var max_follow_distance : float
var wander_time = 0.0
var time_elapsed = 0.0

func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    var distance_vector = enemy.global_position - player.global_position
    if distance_vector.length() < max_follow_distance:
        transitioned.emit(self, "FollowState")
        return
    time_elapsed += delta
    if time_elapsed >= wander_time:
        movement_component.direction = randi_range(-1, 1)
        wander_time = randf_range(0, 4)
        time_elapsed = 0

