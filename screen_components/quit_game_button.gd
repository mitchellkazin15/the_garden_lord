class_name QuitGameButton
extends Button

@export var next_scene : PackedScene


func _ready():
    button_down.connect(_on_button_pressed)


func _on_button_pressed():
    print("quit")
    get_tree().quit()
    
