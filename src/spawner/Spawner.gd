extends Node2D

onready var shape = $SpawnRegion.shape
onready var ray := $RayCast2D
export(PackedScene) var enemy_scene  # Drag the enemy scene here
export(NodePath) var enemies_parent_nodepath  # Drag the enemy scene here
var enemies_parent = null
export var despawn_distance = 2000

func try_spawn():
	assert(shape is CircleShape2D)
	# Random point in a circle
	var radius = shape.radius
	var angle = randf() * TAU  # Random angle
	var distance = sqrt(randf()) * radius  # Random distance (sqrt for uniform distribution)
	var off_pos = position + Vector2(cos(angle), sin(angle)) * distance
	
	ray.cast_to = off_pos
	ray.force_raycast_update()
	if not ray.is_colliding():
		return false
	
	var spawn_pos = to_global(off_pos)
	var enemy = enemy_scene.instance()
	enemy.position = spawn_pos
	enemies_parent.add_child(enemy)
	
	var collision = enemy.move_and_collide(Vector2.UP, true, true, true)
	if collision:
		enemy.queue_free()  # Remove if invalid
		return false

	return true

func spawn():
	for _i in range(10):
		var ok = try_spawn()
		if ok == true:
			return

func despawn():
	var enemies = enemies_parent.get_children()
	print('%d enemies remaining' % enemies.size())
	for enemy in enemies:
		if enemy.global_position.distance_to(global_position) > despawn_distance:
			enemy.queue_free()

func _on_Timer_timeout():
	spawn()

func _ready():
	randomize()
	enemies_parent = get_node(enemies_parent_nodepath)
