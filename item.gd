extends RigidBody3D

@onready var head = $"../ProtoController/Head";
@onready var main = $"../";
@onready var controller = $"../ProtoController";

func interact(callback: Callable):
	await callback.call(false);
	get_parent().remove_child(self);
	head.add_child(self);
	self.position = Vector3(0.5, -0.4, -0.5);
	self.freeze = true;
	$"CollisionShape3D".disabled = true;
	controller.held_item = self;

func drop():
	var global_pos = self.global_position;
	get_parent().remove_child(self);
	main.add_child(self);
	self.position = global_pos;
	self.freeze = false;
	$"CollisionShape3D".disabled = false;
	controller.held_item = null;
