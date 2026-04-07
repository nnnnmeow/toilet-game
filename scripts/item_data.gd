extends Resource;
class_name ItemData;

enum Categorie {
	Shit,
	Alcohol,
	Food,
	Money,
	Materials,
	Rare,
	Upgrade
}

@export var category: Categorie;
@export var item_name: String;
@export var path_to_resource: String;
