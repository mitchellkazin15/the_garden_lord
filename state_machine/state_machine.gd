class_name StateMachine
extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
    for child in get_children():
        if child is State:
            child.transitioned.connect(_on_state_transition)
            states[child.name.to_lower()] = child

    assert(initial_state)
    current_state = initial_state
    current_state.enter()      


func _process(delta):
    if current_state:
        current_state.update(delta)


func _physics_process(delta):
    if current_state:
        current_state.physics_update(delta)


func _on_state_transition(old_state : State, new_state_name : String):
    if old_state != current_state:
        return

    var new_state = states.get(new_state_name.to_lower())
    if !new_state:
        return

    current_state.exit()
    new_state.enter()
    current_state = new_state
    
