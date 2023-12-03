class_name MainMenuButton
extends Button


func _ready():
    button_down.connect(_on_button_pressed)


func _on_button_pressed():
    get_tree().change_scene_to_packed(preload("res://main_menu.tscn"))
    pass
