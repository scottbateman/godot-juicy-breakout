extends ColorRect

@onready var HUD = get_node("/root/Game/HUD")
var c = 0
var colors = [
	Color8(0,0,0),			#black
	Color8(33,37,41),		#gray 9
	Color8(52,58,64),		#gray 8
	Color8(33,37,41),		#gray 9
]


func _ready():
	HUD.connect("changed", Callable(self, "_on_HUD_changed"))
	update_color()


func update_color():
	if HUD.color_background:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "color", colors[c], $Timer.wait_time-0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		color = Color(0,0,0,1)

func _on_HUD_changed():
	update_color()


func _on_Timer_timeout():
	if HUD.color_background:
		c = wrapi(c+1, 0, colors.size())
		update_color()
