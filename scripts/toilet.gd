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
	2: "Enemy",
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

var event_flavor_texts = [
	"The lights flicker for a moment.",
	"You hear something scratching behind the wall.",
	"A cold breeze passes through the room.",
	"The toilet gurgles but nothing comes out.",
	"You feel like someone is watching you.",
	"Distant laughter echoes from the pipes.",
	"The water in the bowl briefly turns red.",
]

# set by try_flushing, read by controller for the drop_text HUD
var last_result_text : String = ""


func interact():
	var res = try_flushing();
	if str(res) != "no_flush":
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
		elif drop == "Enemy":
			spawn_enemy()
			last_result_text = "Something crawled out of the toilet!"
		elif drop == "Event":
			last_result_text = event_flavor_texts[rng.randi_range(0, event_flavor_texts.size() - 1)]
		return drop
	else:
		return "no_flush"

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
	last_result_text = "You got %s" % item_data.item_name
	var path = item_data.path_to_resource;
	var body = RigidBody3D.new();
	var model = load(path).instantiate();
	
	var collision = CollisionShape3D.new();
	collision.shape = BoxShape3D.new();
	collision.name = "CollisionShape3D"
	
	body.add_child(model);
	body.add_child(collision);
	body.set_script(load("res://scripts/item.gd"));
	body.item_data = item_data
	add_child(body)
	body.position = self.position + Vector3(-0.15, 0.5, -0.5);
	body.apply_impulse(Vector3(0, 4, -2));


func spawn_enemy():
	var body = CharacterBody3D.new()

	var mesh_instance = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.5, 1.4, 0.5)
	mesh_instance.mesh = mesh
	mesh_instance.position.y = 0.7

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.15, 0, 0)
	mat.emission_enabled = true
	mat.emission = Color(0.7, 0, 0)
	mesh_instance.material_override = mat

	var collision = CollisionShape3D.new()
	var shape = CapsuleShape3D.new()
	shape.radius = 0.3
	shape.height = 1.4
	collision.shape = shape
	collision.position.y = 0.7
	collision.name = "CollisionShape3D"

	body.add_child(mesh_instance)
	body.add_child(collision)
	body.set_script(load("res://scripts/enemy.gd"))

	get_tree().current_scene.add_child(body)
	body.global_position = global_position + Vector3(0, 0.5, 0)
