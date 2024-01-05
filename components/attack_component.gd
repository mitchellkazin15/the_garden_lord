class_name AttackComponent
extends Area2D


@export var actor : Player
@onready var hurtbox : CollisionPolygon2D = $CollisionPolygon2D
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_active_timer : Timer = $AttackActiveTimer
@onready var attack_speed_timer : Timer = $AttackSpeedTimer
@export var attack_time : float = 0.2
var can_attack = true
var attack_dir = 0


func _ready():
    visible = false
    hurtbox.disabled = true
    var num_frames = animation.get_sprite_frames().get_frame_count("default")
    var new_framerate =  float(num_frames) / attack_time
    animation.get_sprite_frames().set_animation_speed("default", new_framerate)
    attack_active_timer.one_shot = true
    attack_speed_timer.one_shot = true
    area_entered.connect(_on_area_entered)


func _physics_process(delta):
    if attack_active_timer.time_left == 0:
        visible = false
        hurtbox.disabled = true
        animation.stop()
        visible = false
    if attack_speed_timer.time_left == 0:
        can_attack = true
    if not can_attack:
        return
    if attack_dir != 0:
        visible = true
        animation.play("default")
        hurtbox.disabled = false
        attack_active_timer.start(attack_time)
        attack_speed_timer.start(actor.stats.get_modified_stat(Stats.names.ATTACK_SPEED))
        can_attack = false
        actor.call_deferred("flip_model", attack_dir)
        scale.x = attack_dir


func _on_area_entered(area):
    var entity_attacked = area.get_parent()
    var entity_health_component : HealthComponent = entity_attacked.find_child("HealthComponent")
    var entity_movement_component : MovementComponent = entity_attacked.find_child("MovementComponent")
    if entity_health_component:
        entity_health_component.apply_damage(actor.stats.get_modified_stat(Stats.names.DAMAGE))
    if entity_movement_component:
        var distance_vector = entity_attacked.global_position - actor.global_position
        entity_movement_component.apply_impulse(distance_vector.normalized() * actor.stats.get_modified_stat(Stats.names.MASS))
        actor.find_child("MovementComponent").apply_impulse(-distance_vector.normalized() * entity_attacked.stats.get_modified_stat(Stats.names.MASS))
