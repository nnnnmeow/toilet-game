extends RigidBody3D

var head: Node3D                                                                                                                                                                                                                                                                      
var controller: Node3D

func _ready():                                                                                                                                                                                                                                                                        
	controller = get_tree().get_first_node_in_group("player")
	head = controller.get_node("Head")

func interact():
	get_parent().remove_child(self);
	head.add_child(self);
	self.position = Vector3(0.5, -0.4, -0.5);
	self.rotation = Vector3.ZERO
	self.freeze = true;
	$"CollisionShape3D".disabled = true;
	controller.held_item = self;

func drop():
	var global_pos = self.global_position;
	var tree = get_tree()
	get_parent().remove_child(self);
	tree.root.add_child(self);
	self.position = global_pos;
	self.freeze = false;
	$"CollisionShape3D".disabled = false;
	controller.held_item = null;
