extends Node2D

signal player_transform(old_player, new_player)


func _on_player_transform(old_player, new_player):
    get_tree().current_scene.add_child(new_player)
    #print(old_player.get_children())
    var remote_transform = old_player.find_child("RemoteTransform2D")
    print(remote_transform)
    new_player.global_position = old_player.global_position
    remote_transform.reparent(new_player)
    old_player.queue_free()
    print("transforming")
    pass # Replace with function body.
