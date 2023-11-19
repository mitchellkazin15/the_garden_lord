extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
const GRAVITY = 1500 # pixels per second per second of acceleration
const AIR_ROTATION_DEG_PER_SEC = 360


# Called when the node enters the scene tree for the first time.
func _ready():
    $AntAnimation.play("idle")


func is_on_surface():
    if !(is_on_floor() or is_on_wall() or is_on_ceiling()):
        $RayCast2D.force_raycast_update()
        return $RayCast2D.is_colliding()
    return true


func get_surface_normal():
    $RayCast2D.force_raycast_update()
    return $RayCast2D.get_collision_normal()


func move_along_surface(direction):
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var on_surface = is_on_surface()
    if on_surface:
        var normal = get_surface_normal()#$RayCast2D.get_collision_normal()
        rotation = normal.angle() + deg_to_rad(90)

    if Input.is_action_pressed("move_right"):
        var sprint = 1.5 if Input.is_action_pressed("sprint") else 1
        $AntAnimation.flip_h = false
        $Hitbox.scale.x = 1
        if !on_surface:
            if sprint != 1:
                rotation += deg_to_rad(AIR_ROTATION_DEG_PER_SEC * delta)
            else:
                velocity.x = speed
        else:
            var normal = get_surface_normal()
            var rotated = Vector2(-normal.y, normal.x)
            print(normal)
            velocity = speed * rotated * sprint
    elif Input.is_action_pressed("move_left"):
        var sprint = 1.5 if Input.is_action_pressed("sprint") else 1
        $AntAnimation.flip_h = true
        $Hitbox.scale.x = -1
        if !on_surface:
            if sprint != 1:
                rotation += deg_to_rad(-AIR_ROTATION_DEG_PER_SEC * delta)
            else:
                velocity.x = -speed
        else:
            var normal = get_surface_normal()
            var rotated = Vector2(normal.y, -normal.x)
            velocity = speed * rotated * sprint
    elif on_surface:
        velocity = Vector2(0,0)

    if Input.is_action_pressed("jump") and on_surface:
        velocity = 750 * get_surface_normal()

    if velocity.length() > 0:
        $AntAnimation.play("walking")
    else:
        $AntAnimation.play("idle")

    if !on_surface:
        velocity.y += GRAVITY * delta
    else:
        velocity += GRAVITY * delta * -get_surface_normal()

    move_and_slide()
