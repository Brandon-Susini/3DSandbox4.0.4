extends CharacterBody3D

signal hit_object

var root
# Movement
var speed
@export var walk_speed = 5.0
@export var run_speed = 7.0
@export var JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 0.003
@export var air_influence = 2.0
@export var stop_speed = 7.0
@onready var player_height = 2.0

# Head bob
@export var BOB_FREQ = 2.0
@export var BOB_AMP = 0.08
var t_bob = 0.0
# Fov
@export var base_fov = 80.0
@export var fov_change = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 9.8

# Head references
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var reticle = $Head/ColorRect

#Ray casting
const RAY_LENGTH = 1000
# @export var from_y = 2

#Drawing
var draw

#Object hit effects
@export var hit_material: Material
var hit_objects = []
var finished_objects = []

# Player attacks


func _ready():
	
	var screen = get_viewport().get_visible_rect().size
	reticle.position = Vector2(screen.x/2,screen.y/2)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	root = self
	while root.get_parent():
		root = root.get_parent()
		print(root)
	draw = Draw3D.new()
	root.call_deferred("add_child",draw)
	
	


func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		match event.button_index:
			1:
				#print("Left Mouse Button")
				pass
			2: 
				#print("Right Mouse Button")
				pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(60))
	

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
#	for obj in hit_objects:
#		obj.material.next_pass.albedo_color.a -= delta

func _physics_process(delta):
	gravity_and_jump(delta)
	walk_and_run(delta)
	#Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#FOV
	var velocity_clamped = clamp( velocity.length(), 0.5, run_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos
	


func gravity_and_jump(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func walk_and_run(delta):
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * stop_speed)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * stop_speed)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * air_influence)
		velocity.z = lerp(velocity.z, direction.z * speed, delta*air_influence)














##Ray Casts
#
#	if Input.is_action_just_pressed("base_light_attack"):
#		draw.clear()
#		var mouse_position = get_viewport().get_mouse_position()
#		var from = camera.project_ray_origin(mouse_position)
#		from.y = head.global_position.y # camera.global_position.y
#		var to = from + camera.project_ray_normal(mouse_position) * 1.5
#		var result = cast_ray(from,to)
#		var boulder = base_attack.instantiate()
#		boulder.position = to
#		boulder.player = self
#		boulder.transform.basis = camera.transform.basis
#		#boulder.position.y += head.global_position.y - player_height/1.5
#		root.call_deferred("add_child",boulder)
#
#	move_and_slide()
#
#
#func cast_ray(from,to):
#	var space_state = get_world_3d().direct_space_state
#	print("Begin base light attack")
#	var query = PhysicsRayQueryParameters3D.create(from,to)
#	query.exclude = [self]
#	var result = space_state.intersect_ray(query)
#	draw.draw_line([from,to], Color.BLACK)
#	if result:
#		draw.cube(result.position)
#		if result.collider.is_in_group("hittable"):
#			result.collider.start_hit_effect(hit_material)
#	print("From: ", from, " To: ",to)
#	return result
