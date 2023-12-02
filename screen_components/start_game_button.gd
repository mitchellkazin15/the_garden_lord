class_name StartGameButton
extends Button

@export var next_scene : PackedScene


func _ready():
    button_down.connect(_on_button_pressed)


func _on_button_pressed():
    get_tree().change_scene_to_packed(next_scene)
    
