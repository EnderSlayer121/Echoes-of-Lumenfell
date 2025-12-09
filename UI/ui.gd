extends CanvasLayer

const MASK_ROW_SIZE = 8
const MASK_OFFSET = 20

func _ready() -> void:
	for count in Main.health:
		var new_mask = Sprite2D.new()
		new_mask.texture = $Mask.texture
		new_mask.hframes = $Mask.hframes
		new_mask.vframes = $Mask.vframes
		$Mask.add_child(new_mask)

func _process(_delta: float) -> void:
	soul_regen()
	for mask in $Mask.get_children():
		var index = mask.get_index()
		var x = (index % MASK_ROW_SIZE) * MASK_OFFSET
		var y = (index / MASK_ROW_SIZE) * MASK_OFFSET
		mask.position = Vector2(x,y)
		
		var last_mask = floor(Main.health)
		if index > last_mask:
			mask.frame = 1
		if index == last_mask:
			mask.frame = (Main.health - last_mask) * 4
		if index < last_mask:
			mask.frame = 0

func soul_regen():
	if Main.soul == 1.0:
		$Soul.frame = 0
	if Main.soul == 0.75:
		$Soul.frame = 1
	if Main.soul == 0.5:
		$Soul.frame = 2
	if Main.soul == 0.25:
		$Soul.frame = 3
	if Main.soul == 0.0:
		$Soul.frame = 4
