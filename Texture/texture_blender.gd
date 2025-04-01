@tool
extends ImageTexture
class_name TextureBlender
@export
var image_one:Texture2D:
	set(value):
		image_one = value
		


@export
var image_two:Texture2D:
	set(value):
		image_two = value

@export
var resulotion:Vector2 = Vector2.ZERO:
	set(value):
		resulotion = value

@export
var toggle:bool:
	set(value):
		pass



func _init() -> void:
	build()
	pass

func build()->void:
	#var image:Image = Image.create_empty(resulotion.x, resulotion.y, false, Image.FORMAT_RGBA8)
	print("test")
	set_image(image_one.get_image())
	print(image_one.get_image())
	pass
