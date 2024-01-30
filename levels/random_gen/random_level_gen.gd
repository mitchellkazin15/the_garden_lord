class_name RandomLevelGen
extends Node

@export var seed = 0
static var base_component_res : Resource = preload("res://levels/random_gen/template_level_component.tscn")


static func random_level(grid_width, grid_height):
    var grid = []
    for i in grid_width:
        grid.append([])
        for j in grid_height:
            grid[i].append(false)

    var parent_node = Node2D.new()
    var top_components = get_file_paths_by_extension("res://levels/random_gen/top/", "tscn")
    var left_slope_components = get_file_paths_by_extension("res://levels/random_gen/left_slope/", "tscn")
    var right_slope_components = get_file_paths_by_extension("res://levels/random_gen/right_slope/", "tscn")
    var valley_components = get_file_paths_by_extension("res://levels/random_gen/valley/", "tscn")
    var boss_arena_components = get_file_paths_by_extension("res://levels/random_gen/boss_arena/", "tscn")
    var height
    var prev_height
    var prev_higher = false
    for i in grid_width + 1:
        if not prev_height or i == 1:
            height = grid_height / 2
        else:
            height = min(max(prev_height + randi_range(-1, 1), 0), grid_height - 1)
        if i < grid_width:
            grid[i][height] = true
        var comp
        if i == 0:
            prev_height = height
            continue
        elif i == 1:
            comp = base_component_res.instantiate()
        elif i == grid_width:
            comp = get_random_component_from_list(boss_arena_components)
            if prev_higher:
                prev_height += 1
        elif prev_higher:
            if height > prev_height:
                comp = get_random_component_from_list(valley_components)
            else:
                comp = get_random_component_from_list(right_slope_components)
            prev_higher = height < prev_height
        elif height <= prev_height:
            comp = get_random_component_from_list(top_components)
            prev_higher = height < prev_height
        elif height > prev_height:
            comp = get_random_component_from_list(left_slope_components)
        
        comp.position.x = (i - 1) * 5000
        comp.position.y = prev_height * -2500 + (grid_height / 2) * 2500
        parent_node.add_child(comp)
        comp.owner = parent_node
        
        prev_height = height
    return parent_node

#    var top_components = get_file_paths_by_extension("res://levels/random_gen/top/", "tscn")
#    var left_slope_components = get_file_paths_by_extension("res://levels/random_gen/left_slope/", "tscn")
#    var right_slope_components = get_file_paths_by_extension("res://levels/random_gen/right_slope/", "tscn")
#    for i in grid_width:
#        grid.append([])
#        for j in grid_height:
#            if grid[i][j]:
#                var comp
#                if i == 0:
#                    comp = level_component_res.instantiate()
#                elif 
#                comp.position.x = i * 5000
#                comp.position.y = j * -2500 + (grid_height / 2) * 2500
#                parent_node.add_child(comp)
#                comp.owner = parent_node
#    var level_components = get_file_paths_by_extension("res://levels/random_gen/", "tscn")
#    var parent_node = Node2D.new()
#    var num_components = randi_range(2, 10)
#    for i in num_components:
#        #var comp = level_component_res.instantiate()
#        var scene = load(level_components[randi_range(0, level_components.size() - 1)])
#        var comp = scene.instantiate()
#        comp.position.x = i * 5000
#        parent_node.add_child(comp)
#        comp.owner = parent_node
#        if randi_range(0, 1) and i > 0:
#            var new_scene = load(level_components[randi_range(0, level_components.size() - 1)])
#            var new_comp = new_scene.instantiate()
#            new_comp.position.x = i * 5000
#            new_comp.position.y = -2500
#            parent_node.add_child(new_comp)
#            new_comp.owner = parent_node
#    return parent_node


static func get_random_component_from_list(comp_list):
    var scene = load(comp_list[randi_range(0, comp_list.size() - 1)])
    return scene.instantiate()


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
