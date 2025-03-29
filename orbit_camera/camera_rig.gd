extends Node3D
class_name CameraRig

var dragging: bool
var panning: bool
var y: float

var pan_start_mouse: Vector3
var pan_start: Vector3

@export var up: float
@export var around: float


func _ready() -> void:
	y = position.y
	set_rotation_values()

func set_rotation_values():
	var dir = Vector3(cos(around), 0, sin(around))
	
	look_at_from_position(position, position + dir)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
			else:
				dragging = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				pan_start_mouse = get_mouse_on_floor_plane()
				pan_start = position
				
				#print("pan_start_mouse: ", pan_start_mouse)
				#print("pan_start: ", pan_start)
				panning = true
			else:
				panning = false
	if event is InputEventMouseMotion:
		if panning:
			var mouse = get_mouse_on_floor_plane()
			if mouse == null:
				return
			var new_mouse = pan_start_mouse - mouse
			#print("## pan_start_mouse: ", pan_start_mouse)
			#print("## mouse: ", mouse)
			#print(new_mouse.length())
			pan_start_mouse = mouse
			position += new_mouse 
			pan_start_mouse = get_mouse_on_floor_plane()
		if dragging:
			var diff = event.screen_relative
			#print(diff)
			around += diff.x * 0.0055
			up -= diff.y * 0.005
			up = clampf(up, deg_to_rad(0), deg_to_rad(60))
			var dir = Vector3(cos(around), 0, sin(around))
			var ddir = Vector3(cos(around-deg_to_rad(90)), 0, sin(around-deg_to_rad(90)))
			dir = dir.rotated(ddir, -up)

			look_at_from_position(position, position + dir)
	pass

func get_mouse_on_floor_plane():
	var mp: Vector2 = get_viewport().get_mouse_position()
	if mp.x > 0 and mp.y > 0:
		var camera: Camera3D = get_viewport().get_camera_3d()
		var floor_plane  = Plane(Vector3(0, 1, 0), 0.0)
			
		return floor_plane.intersects_ray(
			 camera.project_ray_origin(mp),
			 camera.project_ray_normal(mp))
	return Vector3.ZERO
