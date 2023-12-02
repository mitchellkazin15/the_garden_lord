class_name Player
extends CharacterBody2D

@export var stats : BaseStats
@onready var animation = $Animation
@onready var hitbox = $Area2D/Hitbox
var prev_air_rotate_dir = 0


func _ready():
    pass


func is_on_surface():
    return is_on_floor() or is_on_wall() or is_on_ceiling()


func get_surface_normal(on_surface):
    if on_surface:
        return get_floor_normal()
    return null


func flip_model(flip):
    if flip == 0:
        return
    animation.flip_h = flip < 0
    hitbox.scale.x = flip


func set_animation():
    if velocity.length() > 0:
        animation.play("walking")
    else:
        animation.play("idle")

