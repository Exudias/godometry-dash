extends Camera2D

@export var followed_object : Node2D
@export var x_offset : float

func _physics_process(_delta: float) -> void:
	position.x = followed_object.position.x + x_offset
