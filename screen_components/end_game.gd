extends CanvasLayer

@onready var label : Label = $Label
@onready var restart : StartGameButton = $StartGameButton
@onready var quit : QuitGameButton = $QuitGameButton
@onready var main_menu : MainMenuButton = $MainMenuButton


func _ready():
    hide_all()
    restart.button_down.connect(hide_all)
    quit.button_down.connect(hide_all)
    main_menu.button_down.connect(hide_all)


func hide_all():
    print("hiding")
    hide()
    restart.disabled = true
    quit.disabled = true
    main_menu.disabled = true


func show_all():
    print("showing")
    show()
    restart.disabled = false
    quit.disabled = false
    main_menu.disabled = false
