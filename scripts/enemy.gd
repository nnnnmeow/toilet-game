extends CharacterBody3D

const SPEED : float = 2.5
const DAMAGE : float = 15.0
const ATTACK_COOLDOWN : float = 1.5
const ATTACK_RANGE : float = 1.5

var controller: Node3D = null
var attack_timer: float = 0.0
var fleeing: bool = false
var flee_timer: float = 0.0


func _ready():
	add_to_group("enemies")
	controller = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if fleeing:
		flee_timer -= delta
		position.y -= delta * 1.5
		if flee_timer <= 0:
			queue_free()
		return

	if controller == null or controller.is_dead:
		return

	attack_timer = max(attack_timer - delta, 0.0)

	var to_player = controller.global_position - global_position
	to_player.y = 0
	var distance = to_player.length()

	if distance > 0.1:
		var dir = to_player.normalized()
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0

	move_and_slide()

	# face the player
	if distance > 0.05:
		var target_pos = Vector3(controller.global_position.x, global_position.y, controller.global_position.z)
		look_at(target_pos, Vector3.UP)

	if distance < ATTACK_RANGE and attack_timer <= 0:
		attack()


func attack():
	if controller == null or controller.is_dead:
		return
	controller.hp = max(controller.hp - DAMAGE, 0.0)
	attack_timer = ATTACK_COOLDOWN


## Player licked the enemy back. It's grossed out and flees into the floor.
func parry():
	if fleeing:
		return
	fleeing = true
	flee_timer = 1.5
	$CollisionShape3D.disabled = true
