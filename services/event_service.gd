extends Node2D

signal character_transform(old_character, new_character)
signal character_death(character)
signal next_level()


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    character_transform.connect(_on_player_transform)
    character_death.connect(_on_character_death)
    next_level.connect(_on_next_level)


func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        if not get_tree().paused:
            get_tree().paused = true
            PauseScreen.show()
        else:
            get_tree().paused = false
            PauseScreen.hide()


func _on_player_transform(old_character, new_character):
    get_tree().current_scene.add_child(new_character)
    var remote_transform = old_character.find_child("RemoteTransform2D")
    print(remote_transform)
    new_character.global_position = old_character.global_position
    remote_transform.reparent(new_character)
    old_character.queue_free()


func _on_character_death(character):
    EndGame.show_all()
    if get_tree().get_nodes_in_group("Enemy").size() == 1:
        EndGame.label.text = "You Win :)"
        EndGame.show()
    if character.name == "Player":
        EndGame.label.text = "You Lose :("
    character.queue_free()
    pass


func _on_next_level():
    var level = RandomLevelGen.random_level()
    var player = preload("res://player/player.tscn").instantiate()
    player.position.x = 0
    player.position.y = -100
    level.add_child(player)
    player.owner = level
    var scene = PackedScene.new()
    scene.pack(level)
    ResourceSaver.save(scene, "res://test_packed_scene.tscn")
    get_tree().change_scene_to_packed(scene)
