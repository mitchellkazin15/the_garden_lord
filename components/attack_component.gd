class_name AttackComponent
extends Area2D

@export var actor : Player
@onready var hurtbox : CollisionPolygon2D = $CollisionPolygon2D
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $Timer
@export var attack_time : float = 0.2
var attack_dir = 0
var attacking = false

func _ready():
    visible = false
    hurtbox.disabled = true
    var num_frames = animation.get_sprite_frames().get_frame_count("default")
    var new_framerate =  float(num_frames) / attack_time
    animation.get_sprite_frames().set_animation_speed("default", new_framerate)


func _physics_process(delta):
    if attack_dir == 0 or attacking:
        return
    attacking = true
    actor.call_deferred("flip_model", attack_dir)
    scale.x = attack_dir
    animation.play("default")
    visible = true
    hurtbox.disabled = false
    timer.one_shot = true
    timer.start(attack_time)


func _on_attack_timeout():
    attacking = false
    animation.stop()
    visible = false
    hurtbox.disabled = true


func _on_enemy_entered(body):
    print("ATTACK!")
    pass # Replace with function body.
