class_name Player
extends CharacterBody2D

@export var stats : BaseStats
@onready var animation = $Animation
@onready var hitbox = $Area2D/Hitbox
var prev_air_rotate_dir = 0


# Called when the node enters the scene tree for the first time.
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


func accelerate(delta, direction, acceleration, final_speed, decel = false):
    var velocity_scalar = velocity.length()
    velocity = direction.normalized() * (velocity_scalar + acceleration * delta)
    if ((velocity.length() > final_speed and not decel) or 
        ((velocity.angle_to(direction) != 0) and decel)):
        velocity = direction.normalized() * final_speed
    


func set_velocity_from_input(delta, on_surface, surface_normal):
    var prev_velocity = velocity
    var direction = Input.get_axis("move_left", "move_right")
    
    var sprint = stats.sprint_multiplier if Input.is_action_pressed("sprint") else 1.0
    if !on_surface:
        var air_rotate_direction = Input.get_axis("air_rotate_ccw", "air_rotate_cw") * sign(hitbox.scale.x)
        rotation += deg_to_rad(air_rotate_direction * stats.air_rotation_deg_per_sec * delta)
        if direction != 0:
            velocity.x = direction * abs(prev_velocity.x)
    elif direction != 0:
        var tangent = Vector2(-direction * surface_normal.y, direction * surface_normal.x)
        accelerate(delta, tangent, stats.acceleration * sprint, stats.speed * sprint)
        flip_model(direction)
    else:
        var prev_direction = sign(surface_normal.angle_to(velocity))
        var tangent = Vector2(-prev_direction * surface_normal.y, prev_direction * surface_normal.x)
        accelerate(delta, tangent, stats.friction, 0, true)

    if Input.is_action_just_pressed("jump") and on_surface:
        velocity = (stats.jump_speed * surface_normal) + prev_velocity


func apply_gravity(delta, on_surface, surface_normal):
    if !on_surface:
        velocity.y += stats.gravity * delta
        if Input.is_action_just_released("jump") and velocity.length() > stats.jump_speed / 2 and velocity.y < 0:
            velocity = velocity.normalized() * (stats.jump_speed / 2)
    else:
        velocity += stats.gravity * delta * -surface_normal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var on_surface = is_on_surface()
    var normal = get_surface_normal(on_surface)
    if on_surface:
        up_direction = normal
        rotation = normal.angle() + deg_to_rad(90)
    else:
        up_direction = Vector2(0, -1)

    set_velocity_from_input(delta, on_surface, normal)
    apply_gravity(delta, on_surface, normal)
    move_and_slide()
    set_animation()
    var attack_dir = Input.get_axis("ui_left", "ui_right")
    flip_model(attack_dir)
