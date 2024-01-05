class_name StartGameButton
extends Button


func _ready():
    button_down.connect(_on_button_pressed)


func _input(event):
    if Input.is_action_just_pressed("ui_accept") and not disabled:
        _on_button_pressed()
        var parent = get_parent()
        if parent.name == "EndGame":
            parent.hide_all()


func _on_button_pressed():
    EventService.next_level.emit()
