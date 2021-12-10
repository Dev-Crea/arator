extends Node2D

const PRICE = 2

onready var life = 20
onready var attack = 5

func _ready():
	if !Values.is_connected("buy", Values, "update_coins"):
		# warning-ignore:return_value_discarded
		Values.connect("buy", Values, "update_coins")
	
func pay():
	Values.coins -= PRICE
	Values.emit_signal("buy")

func walk():
	$AnimatedSprite.play("walk")

func hurt():
	$AnimatedSprite.play("hurt")

func death():
	$AnimatedSprite.play("death")

func idle():
	$AnimatedSprite.play("idle")

func _on_Degat_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	print("[_on_Degat_area_shape_entered] Tower punk have damage ! ", area.is_in_group("mob"))
	$AnimatedSprite.play("hurt")

func _on_Degat_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	print("[_on_Degat_area_shape_exited] Tower punk stop degat ! ", area.is_in_group("mob"))
	$AnimatedSprite.play("idle")

func _on_Attack_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	print("[_on_Attack_area_shape_entered] Tower punk attack ! ", area.is_in_group("mob"))
	if area.is_in_group("mob"):
		$AnimatedSprite.play("attack")
		area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().emit_signal("hit", attack)

func _on_Attack_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if area != null:
		print("[_on_Attack_area_shape_exited] Tower punk stop attack mob ! ", area.is_in_group("mob"))
		$AnimatedSprite.play("idle")
		$explode.playing = false
	$explode.visible = false
