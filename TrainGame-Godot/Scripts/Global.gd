extends Node

const WORLD_FOLDER := "user://Worlds/"
const SAVE_FILE_EXTENSION := ".tg"

var Registry := preload("res://Scripts/Registry.gd").new()

var world_name := "Unnamed"
var world_save_location := "user://Worlds/world1.tg"
