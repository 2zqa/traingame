extends Node

const WORLD_FOLDER := "user://Worlds/"
const SAVE_FILE_EXTENSION := ".tg"

var Registry := preload("res://Scripts/Registry.gd").new()

var world_name := "Testworld"
var world_save_location := WORLD_FOLDER + "test_world" + SAVE_FILE_EXTENSION
