extends StaticBody3D

@onready var head = $"../ProtoController/Head"

func interact(callback: Callable):
	await callback.call(false)
	get_parent().remove_child(self);
	head.add_child(self);
	self.position = Vector3(0.5, -0.4, -0.5);
	$"CollisionShape3D".disabled = true;
