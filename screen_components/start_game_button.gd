class_name StartGameButton
extends Button

@export var next_scene : PackedScene


func _ready():
    button_down.connect(_on_button_pressed)


func _input(event):
    if Input.is_action_just_pressed("ui_accept") and not disabled:
        _on_button_pressed()
        get_parent().hide()


func _on_button_pressed():
    get_tree().change_scene_to_packed(next_scene)
    
