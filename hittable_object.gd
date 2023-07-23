extends Node3D
class_name Hittable

var started = false

func get_custom_class():
	return "Hittable"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.material.next_pass.albedo_color.a > 0:
		self.material.next_pass.albedo_color.a -= delta
	pass


func start_hit_effect(hit_material):
	if !started:
		self.material.next_pass = hit_material.duplicate()
		self.material.next_pass.render_priority = 1
		set_process(true)
		started = true
	else:
		self.material.next_pass.albedo_color.a = 1
