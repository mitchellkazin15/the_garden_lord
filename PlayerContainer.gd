class_name PlayerContainer
extends Node

@export var player : Player
var stats = player.stats


# Called when the node enters the scene tree for the first time.
func _ready():
    player.animation.play("idle")


func is_on_surface():
    return player.is_on_floor() or player.is_on_wall() or player.is_on_ceiling()


func get_surface_normal(on_surface):
    if on_surface:
        return player.get_floor_normal()
    return null


func flip_model(flip):
    if flip == 0:
        return
    player.animation.flip_h = flip < 0
    player.hitbox.scale.x = flip


func set_animation():
    if player.velocity.length() > 0:
        player.animation.play("walking")
    else:
        player.animation.play("idle")


func set_velocity_from_input(delta, on_surface, surface_normal):
    var move_right = Input.is_action_pressed("move_right")
    var move_left = Input.is_action_pressed("move_left")
    var direction = 0
    if move_right:
        direction = 1
    if move_left:
        direction = -1
    var sprint = stats.sprint_multiplier if Input.is_action_pressed("sprint") else 1.0
    if !on_surface:
        if direction != 0:
            player.velocity.x = direction * stats.speed * sprint
        if sprint != 1.0:
            player.rotation += deg_to_rad(direction * stats.air_rotation_deg_per_sec * delta)
    else:
        var rotated = Vector2(-direction * surface_normal.y, direction * surface_normal.x)
        player.velocity = stats.speed * rotated * sprint
        flip_model(direction)

    if Input.is_action_just_pressed("jump") and on_surface:
        player.velocity = stats.jump_speed * surface_normal


func apply_gravity(delta, on_surface, surface_normal):
    if !on_surface:
        player.velocity.y += stats.gravity * delta
        if Input.is_action_just_released("jump") and player.velocity.length() > stats.jump_speed / 2:
            player.velocity = player.velocity.normalized() * (stats.jump_speed / 2)
    else:
        player.velocity += stats.gravity * delta * -surface_normal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var on_surface = is_on_surface()
    var normal = get_surface_normal(on_surface)
    if on_surface:
        player.up_direction = normal
        player.rotation = normal.angle() + deg_to_rad(90)
    else:
        player.up_direction = Vector2(0, -1)

    set_velocity_from_input(delta, on_surface, normal)
    apply_gravity(delta, on_surface, normal)
    player.move_and_slide()
    set_animation()


func grasshopper_transform():
    
