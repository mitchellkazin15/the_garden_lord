class_name HealthComponent
extends Node2D

signal health_update()

@export var actor : Player
@export var invincible_after_damage = false
@export var invincibilty_time = 0.0
@onready var health_bar : TextureProgressBar = $TextureProgressBar
@onready var invincibility_timer : Timer = $Timer
var base_health
var current_health


func _ready():
    await actor.ready
    base_health = actor.stats.get_modified_stat(Stats.names.HEALTH)
    current_health = base_health
    health_update.emit()
    health_bar.max_value = base_health
    health_bar.min_value = 0
    health_bar.value = base_health
    if invincible_after_damage:
        invincibility_timer.one_shot = true
        invincibility_timer.connect("timeout", _on_invincibility_timeout)


func apply_damage(damage):
    if invincible_after_damage and invincibility_timer.time_left != 0:
        return
    current_health -= damage
    if current_health <= 0:
        current_health = 0
        EventService.character_death.emit(actor)
    health_bar.value = current_health
    if invincible_after_damage:
        invincibility_timer.start(invincibilty_time)
        actor.turn_on_flashing_shader()
    health_update.emit()


func apply_healing(health):
    current_health += health
    if current_health >= base_health:
        current_health = base_health
    health_bar.value = current_health
    health_update.emit()


func _on_invincibility_timeout():
    actor.turn_off_flashing_shader()
