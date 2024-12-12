extends CharacterBody2D

@onready var Ball = load("res://Ball/Ball.tscn")
@onready var HUD = get_node("/root/Game/HUD")

@export var speed = 70
@export var distort = Vector2(1.5,1.1)
@export var fall_duration = 3

@onready var collision_transform = $CollisionShape2D.get_transform().get_scale()	


@onready var target_y = position.y

var color = Color8(230,73,128) #Pink 6
var color_s = color.s

func _ready():
	randomize()
	HUD.connect("changed", Callable(self, "_on_HUD_changed"))
	update_color()
	start_paddle()

func _physics_process(_delta):
	var target = get_viewport().get_mouse_position().x
	target = clamp(target, 0, get_viewport().size.x)

	var d = abs(target - position.x)						# distance between the mouse and the paddle
	var p = d / get_viewport().get_visible_rect().size.x	# percentage of the total viewport
	var t = clamp(d, d, speed)							# how much to move the paddle this cycle (maximum of speed)
	var s = sign(target - position.x)					# which direction to move
	
	position.x += s*t

	if HUD.paddle_stretch:
		var w = 1 + 5*(distort.x * p)
		var h = 1 - 5*(1/distort.y * p)
		h = max(h,0.1)
		change_size(w,h)
		color.s = color_s * (1-p)
		update_color()
		$Face.position.x = ($Color.size.x * distort.x * p)/2



func change_size(w, h):
	$Color.scale = Vector2(w, h)
	$CollisionShape2D.set_scale(Vector2(collision_transform.x*w, collision_transform.y*h))


func start_paddle():
	if HUD.paddle_appear:
		var target_pos = position
		position.y = -100
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target_pos, fall_duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)


func update_color():
	if HUD.color_paddle:
		$Color.color = color
	else:
		$Color.color = Color(1,1,1,1)

func emit_particle(pos):
	if HUD.particle_paddle:
		get_parent().find_child("GPUParticles2D").global_position = pos
		get_parent().find_child("GPUParticles2D").emitting = true
		get_parent().find_child("GPUParticles2D").look_at(pos)

func _on_HUD_changed():
	update_color()
