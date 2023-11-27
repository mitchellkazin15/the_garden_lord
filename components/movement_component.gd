class_name MovementComponent
extends Node2D

@export var actor : Player
var direction = 0
var air_rotate_direction = 0
var sprint_pressed = false
var jump_just_pressed = false
var jump_just_released = false



func enforce_max_speed():
    if actor.velocity.length() > actor.stats.max_speed:
        actor.velocity = actor.velocity.normalized() * actor.stats.max_speed


func accelerate(delta, direction_vector, acceleration, final_speed, decel = false):
    var velocity_scalar = actor.velocity.length()
    actor.velocity = direction_vector.normalized() * (velocity_scalar + acceleration * delta)
    if ((actor.velocity.length() > final_speed and not decel) or 
        ((actor.velocity.angle_to(-direction_vector) == 0 or actor.velocity.length() < final_speed) and decel)):
        actor.velocity = direction_vector.normalized() * final_speed


func air_accelerate(delta, acceleration, max_speed):
    actor.velocity.x += direction * acceleration * delta
    print(actor.velocity.x)
    if abs(actor.velocity.x) > max_speed:
        actor.velocity.x = direction * max_speed


func set_velocity_from_input(delta, on_surface, surface_normal):
    var prev_velocity = actor.velocity
    
    var sprint = actor.stats.sprint_multiplier if sprint_pressed else 1.0
    if !on_surface:
        actor.rotation += deg_to_rad(air_rotate_direction * actor.stats.air_rotation_deg_per_sec * delta) * sign(actor.hitbox.scale.x)
        if direction != 0:
            air_accelerate(delta, actor.stats.air_acceleration, actor.stats.max_air_speed)
    elif direction != 0:
        var tangent = Vector2(-direction * surface_normal.y, direction * surface_normal.x)
        if actor.velocity.length() > actor.stats.speed * sprint:
            accelerate(delta, tangent, actor.stats.friction, actor.stats.speed * sprint, true)
        else:
            accelerate(delta, tangent, actor.stats.acceleration * sprint, actor.stats.speed * sprint)
        actor.flip_model(direction)
    elif actor.velocity.length() != 0:
        var prev_direction = sign(surface_normal.angle_to(actor.velocity))
        var tangent = Vector2(-prev_direction * surface_normal.y, prev_direction * surface_normal.x)
        accelerate(delta, tangent, actor.stats.friction, 0, true)

    if jump_just_pressed and on_surface:
        actor.velocity = (actor.stats.jump_speed * surface_normal) + prev_velocity


func apply_gravity(delta, on_surface, surface_normal):
    if !on_surface:
        actor.velocity.y += actor.stats.gravity * delta
        if jump_just_released and actor.velocity.length() > actor.stats.jump_speed / 2 and actor.velocity.y < 0:
            actor.velocity.y = actor.velocity.y / 2
    else:
        actor.velocity += actor.stats.gravity * delta * -surface_normal


func _physics_process(delta):
    var on_surface = actor.is_on_surface()
    var normal = actor.get_surface_normal(on_surface)
    if on_surface:
        actor.up_direction = normal
        actor.rotation = normal.angle() + deg_to_rad(90)
    else:
        actor.up_direction = Vector2(0, -1)
    set_velocity_from_input(delta, on_surface, normal)
    apply_gravity(delta, on_surface, normal)
    enforce_max_speed()
    actor.move_and_slide()
    actor.set_animation()
    
