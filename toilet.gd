extends StaticBody3D

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
		return drop
	else:
		return null

func get_item_by_category():
	return
