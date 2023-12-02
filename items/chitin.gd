class_name Chitin
extends Collectable


func _on_body_entered(body):
    queue_free()


func _on_area_entered(area):
    queue_free()
