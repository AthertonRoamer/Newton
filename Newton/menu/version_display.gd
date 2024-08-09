extends Label

func _ready() -> void:
	text = "Version: " + ProjectSettings.get_setting("application/config/version")
