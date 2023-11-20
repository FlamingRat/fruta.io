extends Node2D
class_name Bucket


var end_l: float
var end_r: float


@onready var wall_left_hitbox: CollisionShape2D = $wallLeft/hitbox
@onready var wall_right_hitbox: CollisionShape2D = $wallRight/hitbox
@onready var bg: Sprite2D = $bg


func _ready():
	var rect_l = wall_left_hitbox.shape.get_rect()
	end_l = wall_left_hitbox.global_position.x + rect_l.size.x / 2

	var rect_r = wall_right_hitbox.shape.get_rect()
	end_r = wall_right_hitbox.global_position.x - rect_r.size.x / 2
	
	bg.texture = Customization.get_skin_resource('bg')
