extends Node2D

@onready var Ball = load("res://Ball/Ball.tscn")
@onready var Cdown = get_node("/root/Game/Starting/Countdown")
@onready var timer = get_node("/root/Game/Starting/Timer")
var countdown = 5
var c = 0

func _ready():
	start_ball()

func start_ball():
	for ch in get_children():
		ch.queue_free()
	c = countdown
	Cdown.show()
	Cdown.text = "Starting in: " + str(c)
	timer.start()

func create_ball():
	var ball = Ball.instantiate()
	ball.position = Vector2(512, 650)
	ball.name = "Ball"
	ball.apply_central_impulse(Vector2(250,-250))
	add_child(ball)


func _on_Timer_timeout():
	c -= 1
	if c > 0:
		Cdown.text = "Starting in: " + str(c)
	else:
		Cdown.text = ""
		Cdown.hide()
		create_ball()
		timer.stop()
