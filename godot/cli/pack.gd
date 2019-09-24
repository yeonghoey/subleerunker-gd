extends SceneTree

# Pack exported image and json data into SpritePack

const sheet_path := "res://sprite_packs/%s/sheet.png"
const data_path := "res://sprite_packs/%s/data.json"
const pack_path := "res://sprite_packs/%s/pack.tres"

const pack_names = [
	"default", "inverted"
]

func _init():
	main()
	quit()

func main():
	for pack_name in pack_names:
		pack(pack_name)

func pack(pack_name: String):
	var sheet = load(sheet_path % pack_name)
	var data = load_json(data_path % pack_name)
	var sprite_pack := SpritePack.new()
	sprite_pack.compile(sheet, data)
	var ret = ResourceSaver.save(pack_path % pack_name, sprite_pack)
	assert ret == OK

func load_json(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	var ret = JSON.parse(content)
	assert ret.error == OK
	return ret.result