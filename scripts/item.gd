extends RigidBody3D

var head: Node3D
var controller: Node3D
var item_data: ItemData = null

func _ready():
	controller = get_tree().get_first_node_in_group("player")
	head = controller.get_node("Head")
	if item_data != null and item_data.category == ItemData.Categorie.Shit:
		add_to_group("trash")

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


func use():
	if item_data == null:
		return
	var cat = item_data.category
	if cat == ItemData.Categorie.Food:
		controller.hunger = min(controller.hunger + 30.0, controller.MAX_HUNGER)
		consume()
	elif cat == ItemData.Categorie.Alcohol:
		# drink is a gamble
		var roll = randf()
		if roll < 0.5:
			controller.hunger = min(controller.hunger + 15.0, controller.MAX_HUNGER)
		else:
			controller.hp = max(controller.hp - 10.0, 0.0)
		consume()
	# other categories not usable from hand yet


func consume():
	controller.held_item = null
	queue_free()
