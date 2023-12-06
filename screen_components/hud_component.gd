class_name HudComponent
extends CanvasLayer

@onready var health_label : Label = $HealthLabel
@onready var chitin_label : Label = $ChitinLabel
@export var inventory_component : InventoryComponent
@export var health_component : HealthComponent


func _ready():
    if inventory_component:
        inventory_component.chitin_update.connect(_on_chitin_update)
        chitin_label.text = "Chitin: " + str(inventory_component.chitin)
    if health_component:
        health_component.health_update.connect(_on_health_update)
        health_label.text = "Health: " + str(health_component.current_health) + "/" + str(health_component.base_health)


func _on_chitin_update():
    chitin_label.text = "Chitin: " + str(inventory_component.chitin)
    pass


func _on_health_update():
    health_label.text = "Health: " + str(health_component.current_health) + "/" + str(health_component.base_health)
    pass
