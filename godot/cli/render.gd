extends SceneTree

# Render scene templates into rendered scenes using SpritePack

const blueprints = [
	{
		"scene": "res://player/default/player.tscn",
		"pack": "res://sprite_packs/default/pack.tres",
		"animation_player": NodePath("./AnimationPlayer"),
		"animated_sprite": NodePath("./AnimatedSprite"),
		"catalog_ids": ["player_idle", "player_run"],
	},
	{
		"scene": "res://player_die/default/player_die.tscn",
		"pack": "res://sprite_packs/default/pack.tres",
		"animation_player": NodePath("./AnimationPlayer"),
		"animated_sprite": NodePath("./AnimatedSprite"),
		"catalog_ids": ["player_die"],
	},
	{
		"scene": "res://flame/default/flame.tscn",
		"pack": "res://sprite_packs/default/pack.tres",
		"animation_player": NodePath("./AnimationPlayer"),
		"animated_sprite": NodePath("./AnimatedSprite"),
		"catalog_ids": ["flame_burn"],
	},
	{
		"scene": "res://flame_land/default/flame_land.tscn",
		"pack": "res://sprite_packs/default/pack.tres",
		"animation_player": NodePath("./AnimationPlayer"),
		"animated_sprite": NodePath("./AnimatedSprite"),
		"catalog_ids": ["flame_land"],
	}
]

func _init():
	main()
	quit()

func main():
	for blueprint in blueprints:
		render(blueprint)

func render(blueprint: Dictionary):
	# Prepare the scene template
	var scene = load(blueprint["scene"])
	var node = scene.instance()
	get_root().add_child(node)

	# Load and render the template using the sprite pack 
	var pack = load(blueprint["pack"])
	var animation_player = node.get_node(blueprint["animation_player"])
	var animated_sprite = node.get_node(blueprint["animated_sprite"])
	var catalog_ids = blueprint["catalog_ids"]
	pack.render(animation_player, animated_sprite, catalog_ids)

	# Save it back
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var ret = ResourceSaver.save(blueprint["scene"], packed_scene)
	assert ret == OK