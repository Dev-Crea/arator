extends CanvasLayer

func _ready():
	Values.update_coins()
	Values.update_lifes()
	Values.update_select_info()
	configure_builder_setting()

func configure_builder_setting():
	pass
