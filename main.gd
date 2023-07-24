extends Node3D

@export var spectator_cam: Camera3D
@export var spectator_screen: Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	spectator_screen.texture = spectator_cam.get_viewport().get_texture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
