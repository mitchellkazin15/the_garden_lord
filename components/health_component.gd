class_name HealthComponent
extends Node2D

@export var actor : Player
@onready var health_bar : TextureProgressBar = $TextureProgressBar
var base_health
var current_health


func _ready():
    base_health = actor.stats.health
    current_health = base_health
    health_bar.max_value = base_health
    health_bar.min_value = 0
    health_bar.value = base_health


func apply_damage(damage):
    current_health -= damage
    if current_health <= 0:
        current_health = 0
        EventService.character_death.emit(actor)
    health_bar.value = current_health


func apply_healing(health):
    current_health += health
    if current_health >= base_health:
        current_health = base_health
    health_bar.value = current_health
