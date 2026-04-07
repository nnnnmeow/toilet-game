extends Resource;
class_name ItemDatabase;

@export var item_list: Array[ItemData];

func get_by_category(category: ItemData.Categorie) -> Array[ItemData]:
	return item_list.filter(func(i): return i.category == category)
