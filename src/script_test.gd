tool
extends Node2D

# Adds a property in the Inspector
export(bool) var call_function setget set_call_function

func set_call_function(value):
	if value:  # When toggled, call the function
		editor_function()
		call_function = false  # Reset the button

func editor_function():
	print("Editor function called from a custom button!")
