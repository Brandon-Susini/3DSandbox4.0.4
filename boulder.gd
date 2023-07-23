extends Area3D

var player
var direction
var speed = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 0.1
	direction = (global_position - player.global_position).normalized() * 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	position += transform.basis * Vector3(1,1,-speed) * delta
	pass


func _on_body_entered(body):
	print("Hit")
	call_deferred("queue_free")
	pass # Replace with function body.
