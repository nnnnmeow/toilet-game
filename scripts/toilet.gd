extends StaticBody3D

@onready var item_database: Resource = preload("res://resources/item_database.tres");

const FLUSHES_PER_DAY : int = 10
const DAY_LENGTH_SECONDS : float = 900.0  # 15 minutes per day

var flush_amount : int = FLUSHES_PER_DAY
var current_day : int = 1
var time_left : float = DAY_LENGTH_SECONDS
var rng = RandomNumberGenerator.new()
var events_dictionary = {
	1: "Event",
	17: "Enemy",
	100: "Item",
}

var categories_dictionary = {
	1: ItemData.Categorie.Rare,
	3: ItemData.Categorie.Upgrade,
	5: ItemData.Categorie.Alcohol,
	15: ItemData.Categorie.Money,
	40: ItemData.Categorie.Food,
	70: ItemData.Categorie.Materials,
	100: ItemData.Categorie.Shit,
}


func interact():
	var res = try_flushing();
	if res != "":
		%FlushSFX.play()
		%AnimationPlayer.play("flush")
		return res
	else:
		%MicrowaveDoorOpen.play()
		return null


func try_flushing():
	if flush_amount > 0:
		var drop_chance = rng.randf_range(0, 100.0)
		var category_chance = rng.randf_range(0, 100.0);
		var drop;
		var category;
		for drops in events_dictionary:
			if drops >= drop_chance:
				drop = events_dictionary[drops]
				break
		flush_amount -= 1
		if drop == "Item":
			for categories in categories_dictionary:
				if categories >= category_chance:
					category = categories_dictionary[categories]
					break
			spawn_item(category)
		return drop
	else:
		return null

func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		end_day()


func end_day():
	current_day += 1
	flush_amount = FLUSHES_PER_DAY
	time_left = DAY_LENGTH_SECONDS


func spawn_item(category):
	var items = item_database.get_by_category(category);
	var item_chance = rng.randi_range(0, items.size() - 1);
	var item_data = items[item_chance];
	var path = item_data.path_to_resource;
	var body = RigidBody3D.new();
	var model = load(path).instantiate();
	
	var collision = CollisionShape3D.new();
	collision.shape = BoxShape3D.new();
	collision.name = "CollisionShape3D"
	
	body.add_child(model);
	body.add_child(collision);
	body.set_script(load("res://scripts/item.gd"));
	add_child(body)
	body.position = self.position + Vector3(-0.15, 0.5, -0.5);
	body.apply_impulse(Vector3(0, 4, -2));
