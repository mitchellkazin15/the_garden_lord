class_name Player
extends CharacterBody2D

@export var stats : BaseStats
@onready var animation = $Animation
@onready var hitbox = $Area2D/Hitbox
var frame_done = false


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


func set_velocity_from_input(delta, on_surface, surface_normal):
    var prev_vel = velocity
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
            velocity.x = direction * stats.speed * sprint
        if sprint != 1.0:
            rotation += deg_to_rad(direction * stats.air_rotation_deg_per_sec * delta)
    else:
        var rotated = Vector2(-direction * surface_normal.y, direction * surface_normal.x)
        velocity = stats.speed * rotated * sprint
        flip_model(direction)

    if Input.is_action_just_pressed("jump") and on_surface:
        velocity = (stats.jump_speed * surface_normal)


func apply_gravity(delta, on_surface, surface_normal):
    if !on_surface:
        velocity.y += stats.gravity * delta
        if Input.is_action_just_released("jump") and velocity.length() > stats.jump_speed / 2 and velocity.y < 0:
            velocity = velocity.normalized() * (stats.jump_speed / 2)
    else:
        velocity += stats.gravity * delta * -surface_normal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    frame_done = false
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
    frame_done = true


func transform_model(new_model):
    new_model.position = position
    print(animation)
    print(hitbox)
    get_tree().paused = true
    get_tree().current_scene.add_child(new_model)
    print("pausing")
    while not frame_done:
        print("frame not done")
        pass
    print("frame done")
    animation = new_model.get_child(0)
    hitbox = new_model.get_child(1)
    add_child(animation)
    add_child(hitbox)
    print(animation)
    print(hitbox)
    get_tree().paused = false
