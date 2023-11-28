class_name Enemy
extends CharacterBody2D

@onready var health_bar : TextureProgressBar = $TextureProgressBar
var health = 100


func _on_attack_entered(area):
    if not area.collision_layer & 0b100000:
        return
    area.get_parent().attack_collision(Vector2.LEFT)
    health -= 10
    health_bar.value -= 10
    if health <= 0:
        queue_free()