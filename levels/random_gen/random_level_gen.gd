class_name RandomLevelGen
extends Node

@export var seed = 0
static var level_component_res : Resource = preload("res://levels/random_gen/template_level_component.tscn")


static func random_level():
    var level_components = get_file_paths_by_extension("res://levels/random_gen/", "tscn")
    var parent_node = Node2D.new()
    var num_components = randi_range(2, 10)
    for i in num_components:
        #var comp = level_component_res.instantiate()
        var scene = load(level_components[randi_range(0, level_components.size() - 1)])
        var comp = scene.instantiate()
        comp.position.x = i * 5000
        parent_node.add_child(comp)
        comp.owner = parent_node
        if randi_range(0, 1) and i > 0:
            var new_scene = load(level_components[randi_range(0, level_components.size() - 1)])
            var new_comp = new_scene.instantiate()
            new_comp.position.x = i * 5000
            new_comp.position.y = -2500
            parent_node.add_child(new_comp)
            new_comp.owner = parent_node
    return parent_node


static func get_file_paths_by_extension(directoryPath: String, extension: String, recursive: bool = true) -> Array:
    var dir := DirAccess.open(directoryPath)
    if not dir:
        print("Warning: could not open directory: ", directoryPath)
        return []

    dir.list_dir_begin()
    var filePaths := []
    var fileName = dir.get_next()

    while fileName:
        if dir.current_is_dir():
            if recursive:
                var dirPath = dir.get_current_dir() + "/" + fileName
                filePaths += get_file_paths_by_extension(dirPath, extension, recursive)
        else:
            if fileName.get_extension() == extension:
                var filePath = dir.get_current_dir() + "/" + fileName
                filePaths.append(filePath)
    
        fileName = dir.get_next()
    
    return filePaths
