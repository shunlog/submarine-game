tool
extends Node2D

## Run all the generation layers,
## assuming they are all children of this node
export(bool) var generate setget set_generate
func set_generate(value):
	if value:  # When toggled, call the function
		var c = get_children()
		for i in range(c.size()):
			var n = c[i]
			var orig = n.replace
			n.replace = true if i > 0 else false
			n.generate = true
			n.replace = orig
		generate = false  # Reset the button

 
