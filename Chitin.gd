extends Area2D

signal grasshopper_transform

func _on_body_entered(body):
    grasshopper_transform.emit()
    queue_free()
