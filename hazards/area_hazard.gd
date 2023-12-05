class_name AreaHazard
extends Area2D

@onready var timer : Timer = $Timer
@export var damage = 5
@export var bounce_vel = 500
@export var re_damage_timer = 0.2
var re_damage_bodies = {}


func _ready():
    body_entered.connect(_on_body_entered)
    timer.connect("timeout", _re_damage)


func _re_damage():
    if not re_damage_bodies:
        timer.stop()
    for body in re_damage_bodies.keys():
        var health_component = body.find_child("HealthComponent")
        if health_component:
            health_component.apply_damage(damage)
    pass


func _on_body_entered(body):
    var distance_vector = body.global_position - global_position
    var health_component = body.find_child("HealthComponent")
    var movement_component : MovementComponent = body.find_child("MovementComponent")
    if health_component:
        health_component.apply_damage(damage)
        timer.start(re_damage_timer)
        re_damage_bodies[body] = null
    if movement_component and bounce_vel > 0:
        movement_component.apply_impulse(distance_vector.normalized() * bounce_vel)


func _on_body_exited(body):
    re_damage_bodies.erase(body)
