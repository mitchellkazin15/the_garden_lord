class_name GrasshopperItem
extends Collectable


func _on_body_entered(body):
    EventService.player_transform.emit(body, preload("res://grasshopper.tscn").instantiate())
    queue_free()
#    if body.has_method("transform_model"):
#        body.transform_model(preload("res://grasshopper.tscn").instantiate())
#        queue_free()


func _on_area_entered(area):
    EventService.player_transform.emit(area.get_parent(), preload("res://grasshopper.tscn").instantiate())
    queue_free()
    pass # Replace with function body.
