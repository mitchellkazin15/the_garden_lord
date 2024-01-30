class_name MovementComponent
extends Node2D

@export var actor : Player
var direction = 0
var air_rotate_direction = 0
var sprint_pressed = false
var crouch_pressed = false
var jump_just_pressed = false
var jump_just_released = false


func get_facing_direction():
    var angle = actor.rotation
    return Vector2.from_angle(angle) * actor.get_model_dir()


func enforce_max_speed():
    if actor.velocity.length() > actor.stats.get_modified_stat(Stats.names.MAX_SPEED):
        actor.velocity = actor.velocity.normalized() * actor.stats.get_modified_stat(Stats.names.MAX_SPEED)


func accelerate(delta, direction_vector, acceleration, final_speed, decel = false):
    var velocity_scalar = actor.velocity.length()
    actor.velocity = direction_vector.normalized() * (velocity_scalar + acceleration * delta)
    if ((actor.velocity.length() > final_speed and not decel) or 
        ((actor.velocity.angle_to(-direction_vector) == 0 or actor.velocity.length() < final_speed) and decel)):
        actor.velocity = direction_vector.normalized() * final_speed


func air_accelerate(delta, acceleration, max_speed):
    actor.velocity.x += direction * acceleration * delta
    if abs(actor.velocity.x) > max_speed:
        actor.velocity.x = direction * max_speed


func set_velocity_from_input(delta, on_surface, surface_normal):
    var prev_velocity = actor.velocity
    
    var sprint = actor.stats.get_modified_stat(Stats.names.SPRINT_MULTIPLIER) if sprint_pressed else 1.0
    if !on_surface:
        actor.rotation += deg_to_rad(air_rotate_direction * actor.stats.get_modified_stat(Stats.names.AIR_ROTATION_DEG_PER_SEC) * delta) * sign(actor.hitbox.scale.x)
        if direction != 0:
            air_accelerate(delta, actor.stats.get_modified_stat(Stats.names.AIR_ACCELERATION), actor.stats.get_modified_stat(Stats.names.MAX_AIR_SPEED))
    elif direction != 0:
        var tangent = Vector2(-direction * surface_normal.y, direction * surface_normal.x)
        if actor.velocity.length() > actor.stats.get_modified_stat(Stats.names.SPEED) * sprint:
            accelerate(delta, tangent, actor.stats.get_modified_stat(Stats.names.FRICTION), actor.stats.get_modified_stat(Stats.names.SPEED) * sprint, true)
        else:
            accelerate(delta, tangent, actor.stats.get_modified_stat(Stats.names.ACCELERATION) * sprint, actor.stats.get_modified_stat(Stats.names.SPEED) * sprint)
        actor.flip_model(direction)
    elif actor.velocity.length() != 0:
        var prev_direction = sign(surface_normal.angle_to(actor.velocity))
        var tangent = Vector2(-prev_direction * surface_normal.y, prev_direction * surface_normal.x)
        accelerate(delta, tangent, actor.stats.get_modified_stat(Stats.names.FRICTION), 0, true)

    if jump_just_pressed and on_surface:
        actor.velocity = (actor.stats.get_modified_stat(Stats.names.JUMP_SPEED) * surface_normal) + prev_velocity


func elastic_collsion(entity_velocity, entity_mass, entity_position):
    var entity_momentum = entity_velocity * entity_mass
    var actor_momentum = actor.velocity * actor.stats.get_modified_stat(Stats.names.MASS)


func apply_impulse(impulse_velocity):
    actor.velocity += impulse_velocity


func apply_gravity(delta, on_surface, surface_normal):
    if !on_surface:
        actor.velocity.y += actor.stats.get_modified_stat(Stats.names.GRAVITY) * delta
        if jump_just_released and actor.velocity.length() > actor.stats.get_modified_stat(Stats.names.JUMP_SPEED) / 2 and actor.velocity.y < 0:
            actor.velocity.y = actor.velocity.y / 2
    else:
        actor.velocity += actor.stats.get_modified_stat(Stats.names.GRAVITY) * delta * -surface_normal


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
    
