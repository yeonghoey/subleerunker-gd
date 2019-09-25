extends SceneTree

# Render scene templates into rendered scenes using SpritePack

const blueprint = {
	default = {
		animation_player = NodePath("./AnimationPlayer"),
		animated_sprite = NodePath("./AnimatedSprite"),
		sprite = NodePath("./Sprite"),
	},
	entries = [
		{
			default = {type = "animation"},
			scene = "res://player/default/player.tscn",
			pack = "res://sprite_packs/default/pack.tres",
			specs = [
				{catalog_id = "player_idle", loop = true},
				{catalog_id = "player_run", name = "player_run_left", loop = true, flip_h = true},
				{catalog_id = "player_run", name = "player_run_right", loop = true, flip_h = false},
			],
		},
		{
			scene = "res://player_die/default/player_die.tscn",
			pack = "res://sprite_packs/default/pack.tres",
			specs = [{catalog_id = "player_die", type = "animation"}],
		},
		{
			scene = "res://flame/default/flame.tscn",
			pack = "res://sprite_packs/default/pack.tres",
			specs = [{
				type = "animation",
				catalog_id = "flame_burn", 
				loop = true,
			}],
		},
		{
			scene = "res://flame_land/default/flame_land.tscn",
			pack = "res://sprite_packs/default/pack.tres",
			specs = [{
				type = "animation",
				catalog_id = "flame_land",
			}],
		},
		{
			scene = "res://menu/default/menu.tscn",
			pack = "res://sprite_packs/default/pack.tres",
			specs = [
				{
					type = "sprite",
					catalog_id = "logo",
					sprite = NodePath("./Logo")
				},
				{
					type = "animation", 
					catalog_id = "key",
				},
			],
		},
	],
}


func _init():
	main()
	quit()


func main():
	for entry in blueprint["entries"]:
		refurbish(entry)


func refurbish(entry: Dictionary):
	var scene = load(entry["scene"])
	var pack = load(entry["pack"])	
	var specs = entry["specs"]

	# Prepare the scene template
	var node = scene.instance()
	get_root().add_child(node)

	# Load and render the template using the sprite pack 
	for spec in specs:
		var params = compile_params(blueprint, entry, spec)
		match params["type"]:
			"sprite":
				var sprite_path = params["sprite"]
				var sprite = node.get_node(sprite_path)
				pack.refurbish_sprite(sprite, params)
			"animation":
				var animation_player_path = params["animation_player"]
				var animation_player = node.get_node(animation_player_path)
				var animated_sprite_path = params["animated_sprite"]
				var animated_sprite = node.get_node(animated_sprite_path)
				pack.refurbish_animation(animation_player, animated_sprite, params)

	# Save it back
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var ret = ResourceSaver.save(entry["scene"], packed_scene)
	assert ret == OK


func compile_params(blueprint: Dictionary, entry: Dictionary, spec: Dictionary) -> Dictionary:
	var ret := {}

	var blueprint_default = blueprint.get("default", {})
	for key in blueprint_default:
		ret[key] = blueprint_default[key]

	var entry_default = entry.get("default", {})
	for key in entry_default:
		ret[key] = entry_default[key]

	for key in spec:
		ret[key] = spec[key]

	return ret