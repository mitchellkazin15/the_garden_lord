class_name InventoryComponent
extends Node

signal chitin_update()
signal item_update()

var chitin = 0
var items = []


func add_chitin(chitin_count):
    chitin += chitin_count
    chitin_update.emit()


func add_item(item):
    items.any(item)
    item_update.emit()
