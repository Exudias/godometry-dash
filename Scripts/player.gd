extends CharacterBody2D

@export var x_velocity_tiles : float = 1500
@export var jump_height_tiles : float = 2
@export var jump_time : float = 0.25

# Calculated properties
var x_velocity : float
var jump_height : float
var jump_velocity : float
var gravity : float

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE) and self.is_on_floor():
		jump()

	print($Sprite2D.rotation_degrees)
	if not self.is_on_floor():
		$Sprite2D.rotate(PI * delta)
		if $Sprite2D.rotation_degrees > 360:
			$Sprite2D.rotation_degrees -= 0
	else:
		var reset_rotation = $Sprite2D.rotation_degrees
		reset_rotation = fmod(reset_rotation, 360.0)
		var closest_90 = round(reset_rotation / 90.0)
		$Sprite2D.rotation_degrees = closest_90 * 90

func _physics_process(delta: float) -> void:
	apply_half_gravity(delta)
	self.move_and_slide()
	apply_half_gravity(delta)
	
	var last_collision = self.get_last_slide_collision()
	if last_collision and abs(last_collision.get_normal().x) > 0:
		die()
		return

	if global_position.y > 512:
		die()
		return
	
	velocity.x = x_velocity

func _ready() -> void:
	x_velocity = x_velocity_tiles * Constants.TILE_SIZE
	jump_height = jump_height_tiles * Constants.TILE_SIZE
	
	velocity = Vector2(x_velocity, 0)
	
	gravity = (2 * jump_height) / (jump_time ** 2)
	jump_velocity = sqrt(2 * jump_height * gravity)

func die():
	get_tree().reload_current_scene()

func apply_half_gravity(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta * 0.5
	elif velocity.y > 0:
		velocity.y = 0

func jump():
	velocity.y = -jump_velocity
