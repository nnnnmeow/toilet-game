extends StaticBody3D

@onready var inventory = $"../Inventory"

func interact(callback: Callable):
	await callback.call(false)
	inventory.add(name, 1)
	queue_free()
