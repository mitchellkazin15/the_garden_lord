# Must be called from project root folder
godot4 -d -s --path $PWD addons/gut/gut_cmdln.gd -gtest=res://$1 -gmaximize -glog=2
