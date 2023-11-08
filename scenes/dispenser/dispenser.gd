extends Node2D


signal fruit_dropped(level: int)


const STARTING_MAX_SPAWN_LEVEL: int = 3
const TURNS_TO_INCREASE_MAX_SPAWN_LEVEL: float = 7
const FINAL_MAX_SPAWN_LEVEL: int = 5


@export var fruitFactory: PackedScene
@export var level_manager: LevelManager
@export var bucket: Bucket


var current_fruit: Fruit
var next_fruit: Fruit
var turn_count: int = 0


func _ready():
	get_new_fruit()
	promote_fruit()


func get_fruit_size(fruit: Fruit):
	var fruit_box: CollisionShape2D = fruit.get_node('shape')
	return fruit_box.shape.get_rect().size.x * fruit_box.scale.x
	
	
func reposition_fruit():
	current_fruit.animate_promotion(Vector2.ZERO)
	next_fruit.global_position += (
		Vector2.UP *
		(get_fruit_size(next_fruit) / 2 + 4 + get_fruit_size(current_fruit) / 2)
	)


func get_new_fruit():
	var max_spawn_level_increase = floor(
		turn_count / TURNS_TO_INCREASE_MAX_SPAWN_LEVEL
	)
	var max_level = min(
		STARTING_MAX_SPAWN_LEVEL + max_spawn_level_increase,
		FINAL_MAX_SPAWN_LEVEL
	)

	next_fruit = fruitFactory.instantiate()
	next_fruit.level = randi_range(1, max_level)
	next_fruit.level_manager = level_manager
	add_child(next_fruit)
	next_fruit.freeze = true
	
	if current_fruit:
		reposition_fruit()
	
	
func promote_fruit():
	current_fruit = next_fruit
	get_new_fruit()


func drop_fruit():
	turn_count += 1

	remove_child(current_fruit)
	get_tree().current_scene.add_child(current_fruit)

	current_fruit.global_position = global_position
	fruit_dropped.emit(current_fruit.level)
	current_fruit.set_collision_mask_value(1, true)
	current_fruit.set_collision_layer_value(1, true)
	current_fruit.freeze = false
	current_fruit = null
	promote_fruit()


func _physics_process(_delta):
	var follow_coords = get_global_mouse_position()
	var fruit_radius = get_fruit_size(current_fruit) / 2
	position.x = max(min(follow_coords.x, bucket.end_r - fruit_radius), bucket.end_l + fruit_radius)


func _on_level_game_over():
	queue_free()


func _on_input_mask_click_mask_pressed():
	if current_fruit.global_position == global_position:
		drop_fruit()
