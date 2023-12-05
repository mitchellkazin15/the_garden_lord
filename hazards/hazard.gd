class_name Hazard
extends Area2D

@export var damage = 5
@export var bounce_vel = 500


func _ready():
    body_entered.connect(_on_body_entered)


func _on_body_entered(body):
    print(body)
    var distance_vector = body.global_position - global_position
    var health_component = body.find_child("HealthComponent")
    var movement_component : MovementComponent = body.find_child("MovementComponent")
    if health_component:
        health_component.apply_damage(damage)
    if movement_component and bounce_vel > 0:
        movement_component.apply_impulse(distance_vector.normalized() * bounce_vel)
