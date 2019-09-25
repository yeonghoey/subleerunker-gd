extends SceneTree

# Render scene templates into rendered scenes using SpritePack

const pack_fmt = "res://sprite_packs/%s/pack.tres"

const default = {
	animation_player = NodePath("./AnimationPlayer"),
	animated_sprite = NodePath("./AnimatedSprite"),
	sprite = NodePath("./Sprite"),
}

const 	entries = [
{
	pack_names = ["default"],
	scene_fmt = "res://player/%s/player.tscn",
	default = {type = "animation", loop = true},
	specs = [
		{
			catalog_id = "player_idle"
		},
		{
			anim_name = "player_run_left",
			catalog_id = "player_run", 
			flip_h = true,
		},
		{
			anim_name = "player_run_right",
			catalog_id = "player_run", 
			flip_h = false,
		},
	],
},
{
	pack_names = ["default"],
	scene_fmt = "res://player_die/%s/player_die.tscn",
	specs = [
		{
			type = "animation",
			catalog_id = "player_die",
		}
	],
},
{
	pack_names = ["default"],
	scene_fmt = "res://flame/%s/flame.tscn",
	specs = [{
		type = "animation",
		catalog_id = "flame_burn", 
		loop = true,
	}],
},
{
	pack_names = ["default"],
	scene_fmt = "res://flame_land/%s/flame_land.tscn",
	specs = [{
		type = "animation",
		catalog_id = "flame_land",
	}],
},
{
	pack_names = ["default"],
	scene_fmt = "res://menu/%s/menu.tscn",
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
{
	pack_names = ["default"],
	scene_fmt = "res://palette/%s/palette.tscn",
	specs = [
		{
			type = "sprite", 
			catalog_id = "palette_background",
			sprite = NodePath("./Background")
		},
		{
			type = "sprite",
			catalog_id = "palette_current",
			sprite = NodePath("./Current")
		},
	],
},
] # End of "entries"


func _init():
	main()
	quit()


func main():
	var pack_cache = {}
	for entry in entries:
		refurbish(entry, pack_cache)

func refurbish(entry: Dictionary, pack_cache: Dictionary):
	# Entry only params
	var pack_names = entry["pack_names"]
	var scene_fmt  = entry["scene_fmt"]
	var specs = entry["specs"]

	for pack_name in pack_names:
		var pack: SpritePack
		if pack_name in pack_cache:
			pack = pack_cache[pack_name]
		else:
			pack = load(pack_fmt % pack_name)
			pack_cache[pack_name] = pack
		var scene: PackedScene = load(scene_fmt % pack_name)
		var node = scene.instance()
		get_root().add_child(node)
		# Refurbish
		for spec in specs:
			var params = compile_params(entry, spec)
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
		var ret = ResourceSaver.save(scene_fmt % pack_name, packed_scene)
		node.free()
		assert ret == OK


func compile_params(entry: Dictionary, spec: Dictionary = {}) -> Dictionary:
	var ret := {}

	for key in default:
		ret[key] = default[key]

	var entry_default = entry.get("default", {})
	for key in entry_default:
		ret[key] = entry_default[key]

	for key in spec:
		ret[key] = spec[key]

	return ret