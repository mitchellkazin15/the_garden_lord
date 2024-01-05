class_name Stats
extends Resource

## Speed in pixels per second
@export var _base_speed = 400
@export var _base_jump_speed = 750
@export var _base_gravity = 1500
@export var _base_air_rotation_deg_per_sec = 360
@export var _base_air_acceleration = 800
@export var _base_max_air_speed = 1000
@export var _base_max_speed = 3000
@export var _base_sprint_multiplier = 1.5
@export var _base_acceleration = 400
@export var _base_friction = -800
@export var _base_damage = 10
@export var _base_mass = 10
@export var _base_health = 100
@export var _base_attack_speed = 1

const names = {
    SPEED = "speed",
    JUMP_SPEED = "jump_speed",
    GRAVITY = "gravity",
    AIR_ROTATION_DEG_PER_SEC = "air_rotation_deg_per_sec",
    AIR_ACCELERATION = "air_acceleration",
    MAX_AIR_SPEED = "max_air_speed",
    MAX_SPEED = "max_speed",
    SPRINT_MULTIPLIER = "sprint_multiplier",
    ACCELERATION = "acceleration",
    FRICTION = "friction",
    DAMAGE = "damage",
    MASS = "mass",
    HEALTH = "health",
    ATTACK_SPEED = "attack_speed",
}

var _stat_dict = {}


func init_stats():
    var properties = get_property_list()
    for name in names.values():
        for property in properties:
            if property["name"] == "_base_" + name:
                _stat_dict[name] = {
                    "base": get("_base_" + name),
                    "multipliers": [1],
                    "adders": [0],
                }


func get_modified_stat(stat_name):
    var sum_adders = 0
    for adder in _get_stat_adders(stat_name):
        sum_adders += adder
    var sum_multiplier = 0
    for multiplier in _get_stat_multipler(stat_name):
        sum_multiplier += multiplier
    return (_get_base_stat(stat_name) + sum_adders) * sum_multiplier


func _get_base_stat(stat_name):
    return _stat_dict[stat_name]["base"]


func _get_stat_multipler(stat_name):
    return _stat_dict[stat_name]["multipliers"]


func _get_stat_adders(stat_name):
    return _stat_dict[stat_name]["adders"]


func set_stat_multiplier(stat_name, multiplier):
    _stat_dict[stat_name]["multipliers"].append(multiplier)


func set_stat_adder(stat_name, adder):
    _stat_dict[stat_name]["adders"].append(adder)
