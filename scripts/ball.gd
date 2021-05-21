extends RigidBody2D

const SPEED_MODIFIER = 200
const MAX_SPEED = 500

signal game_over

func _ready():
	randomize()

func _integrate_forces(_state):
	for body in get_colliding_bodies():
		if body.has_method("play_sound"):
			body.play_sound()
		if body.has_method("destroy"):
			#body.set_deferred("collision_shape", "disabled", "true")
			body.destroy()
		if body.is_in_group("paddle"):
			var current_speed = linear_velocity.length()
			var direction = position - body.anchor.global_position
			var velocity = direction.normalized() * min(current_speed + SPEED_MODIFIER, MAX_SPEED)
			set_linear_velocity(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	ball_lost()

func ball_lost():
	emit_signal("game_over")
