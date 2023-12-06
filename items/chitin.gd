class_name Chitin
extends Area2D

@export var value = 1


func _on_body_entered(body):
    var inventory_component : InventoryComponent = body.find_child("InventoryComponent")
    if inventory_component:
        inventory_component.add_chitin(value)
        queue_free()


func _on_area_entered(area):
    var inventory_component : InventoryComponent = area.get_parent().find_child("InventoryComponent")
    if inventory_component:
        inventory_component.add_chitin(value)
        queue_free()
