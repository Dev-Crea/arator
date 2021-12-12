extends Node2D

# warning-ignore:unused_signal
signal hit(damage, tower)
# warning-ignore:unused_signal
signal stop_hit(damage, tower)

const VALUE = 1

onready var damaged = 0
onready var life = 15
onready var velocity = 35
onready var mobPathLocation = get_parent()
onready var offset = 0

func _ready():
	_walk()
	
	if !Values.is_connected("buy", Values, "update_coins"):
		# warning-ignore:return_value_discarded
		Values.connect("buy", Values, "update_coins")

func _walk():
	$Path2D/PathFollow2D/AnimatedSprite.play("walk")
	$Path2D/PathFollow2D/explode.playing = false
	$Path2D/PathFollow2D/explode.visible = false

func _hurt():
	$Path2D/PathFollow2D/AnimatedSprite.play("hurt")
	$Path2D/PathFollow2D/explode.playing = true
	$Path2D/PathFollow2D/explode.visible = true

func _death(tower):
	#print("DEATH !!!")
	$Path2D/PathFollow2D/AnimatedSprite.play("death")
	# warning-ignore:return_value_discarded
	$Path2D/PathFollow2D/AnimatedSprite.connect("animation_finished", self, "units_animation_death")
	#print(tower)
	if (tower != null):
		#print("Emit Signal : attack_ended")
		tower.emit_signal("attack_ended")

func set_curve(curve):
	$Path2D.set_curve(curve)

func units_animation_damage(tower):
	_on_MobRat_hit(damaged, tower)

func units_animation_death():
	Values.coins += VALUE
	Values.emit_signal("buy")
	self.queue_free()

func _on_MobRat_hit(damage, tower = null):
	#print("[_on_MobRat_hit] with damage : ", damage)
	damaged = damage
	life -= damage
	_hurt()
	if (life == 0):
		_death(tower)
	else:
		if !$Path2D/PathFollow2D/explode.is_connected("animation_finished", self, "units_animation_damage"):
			# warning-ignore:return_value_discarded
			$Path2D/PathFollow2D/explode.connect("animation_finished", self, "units_animation_damage", [tower])
	#print("Life : ", str(life))

# warning-ignore:unused_argument
func _on_MobRat_stop_hit(damage):
	_walk()
