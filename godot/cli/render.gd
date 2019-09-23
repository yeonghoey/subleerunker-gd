extends SceneTree

# Render scene templates into rendered scenes using SpritePack

const template_path_fmt := "res://scene_templates/%s.tscn"
const pack_path_fmt := "res://sprite_packs/%s/pack.tres"
const rendered_path_fmt := "res://scene_rendered/%s/%s.tscn"


const blueprint = {
	"default": [
		"flame/flame",
	],
	"inverted": [
		"flame/flame",
	],
}

func _init():
	main()
	quit()

func main():
	for pack_name in blueprint:
		var template_names = blueprint[pack_name]
		for template_name in template_names:
			render(pack_name, template_name)

func render(pack_name: String, template_name: String):
	# Prepare the scene template
	var template_scene = load(template_path_fmt % template_name)
	var node = template_scene.instance()
	get_root().add_child(node)

	# Load and render the template using the sprite pack 
	var pack = load(pack_path_fmt % pack_name)
	node.render(pack)

	# Pack the rendered scene and save it
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var rendered_path = rendered_path_fmt % [pack_name, template_name]
	Directory.new().make_dir_recursive(rendered_path.get_base_dir())
	var ret = ResourceSaver.save(rendered_path, packed_scene)
	assert ret == OK