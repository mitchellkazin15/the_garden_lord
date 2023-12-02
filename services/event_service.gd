extends Node2D

signal character_transform(old_character, new_character)
signal character_death(character)


func _ready():
    character_transform.connect(_on_player_transform)
    character_death.connect(_on_character_death)


func _on_player_transform(old_character, new_character):
    get_tree().current_scene.add_child(new_character)
    var remote_transform = old_character.find_child("RemoteTransform2D")
    print(remote_transform)
    new_character.global_position = old_character.global_position
    remote_transform.reparent(new_character)
    old_character.queue_free()


func _on_character_death(character):
    pass
