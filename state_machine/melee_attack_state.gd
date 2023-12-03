class_name MeleeAttackState
extends State

@export var enemy : CharacterBody2D
@export var attack_component : AttackComponent
@export var max_attack_distance : float
var player : Player
var attacked_once = false


func enter():
    player = get_tree().get_first_node_in_group("Player")


func physics_update(delta):
    if not player:
        transitioned.emit(self, "WanderState")
        return
    var distance_vector = player.global_position - enemy.global_position
    if distance_vector.length() > max_attack_distance:
        transitioned.emit(self, "FollowState")
        return
    attack_component.attack_dir = sign(distance_vector.x)


func exit():
    attack_component.attack_dir = 0
