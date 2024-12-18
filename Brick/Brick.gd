extends CharacterBody2D

@onready var HUD = get_node("/root/Game/HUD")
@onready var target_y = position.y

var row = 0
var col = 0

@export var appear_speed = 3
@export var fall_speed = 1.0
@export var rotate_speed = 1.0

var dying = false

var colors = [
	Color8(224,49,49)		#Red 8
	,Color8(253,126,20)		#Orange 6
	,Color8(255,224,102)		#Yellow 3
	,Color8(148,216,45)		#Lime 5
	,Color8(34,139,230)		#Blue 6
	,Color8(190,75,219)		#Violet 5
	,Color8(132,94,247)		#Grape 6
]
@onready var textures = [
	load("res://Assets/smoke0.png")
	,load("res://Assets/smoke1.png")
	,load("res://Assets/smoke2.png")
	,load("res://Assets/smoke3.png")
]

func _ready():
	randomize()
	HUD.connect("changed", Callable(self, "_on_HUD_changed"))
	update_color()

func _process(_delta):
	if dying and not $GPUParticles2D.emitting:
		queue_free()


func start_brick():
	if HUD.blocks_appear:
		var target_pos = position
		var appear_duration = randf()*appear_speed + 1.0
		position.y = -100
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target_pos, appear_duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	else:
		position = Vector2(position.x,target_y)





func update_color():
	if HUD.color_blocks:
		if row >= 0 and row < colors.size():
			$Color.color = colors[row]
	else:
		$Color.color = Color(1,1,1,1)

func emit_particle(pos):
	if HUD.particle_blocks:
		$GPUParticles2D.texture = textures[randi() % textures.size()]
		$GPUParticles2D.emitting = true
		$GPUParticles2D.global_position = pos
	
	
func _on_HUD_changed():
	update_color()


func die():
	var target_color = $Color.color.darkened(0.75)
	target_color.a = 0
	var fall_duration = randf()*fall_speed + 1
	var rotate_amount = (randi() % 1440) - 720
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	if HUD.blocks_fall:
		var target_pos = position
		target_pos.y = 1000
		tween.tween_property(self, "position", target_pos, fall_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	if HUD.blocks_fade:
		tween.tween_property($Color, "color", target_color, fall_duration-0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	if HUD.blocks_rotate:
		tween.tween_property(self, "rotation_degrees", rotate_amount, fall_duration-0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	if not HUD.blocks_fade and not HUD.blocks_fall and not HUD.blocks_rotate:
		$Color.color = target_color
	if not HUD.blocks_rotate:
		rotation = 0

	tween.set_parallel(false)
	tween.tween_property(self, "dying", true, 0)

	collision_layer = 0
	collision_mask = 0
