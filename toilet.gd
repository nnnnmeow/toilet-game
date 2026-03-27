extends StaticBody3D

@onready var whiskey_bottle: Resource =  preload("res://scenes/items/whiskey.tscn");

var flush_amount : int = 10
var rng = RandomNumberGenerator.new()
var events_dictionary = {
	1: "Event",
	17: "Enemy",
	100: "Item",
}
var categories_dictionary = {
	1: "rare_item",
	3: "upgrade",
	5: "alcohol",
	15: "money",
	40: "food",
	70: "materials",
	100: "shit",
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
		var drop;
		for drops in events_dictionary:
			if drops >= drop_chance:
				drop = events_dictionary[drops]
				break
		flush_amount -= 1
		if drop == "Item":
			spawn_item();
		return drop
	else:
		return null

func spawn_item():
	var item = whiskey_bottle.instantiate();
	add_child(item);
	item.position = self.position + Vector3(-0.15, 0.5, -0.5);
	item.apply_impulse(Vector3(0, 4, -2));
