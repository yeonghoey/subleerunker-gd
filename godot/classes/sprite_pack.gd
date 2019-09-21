extends Resource

class_name SpritePack

#warning-ignore:unused_class_variable
export(Dictionary) var data = {}

func head(id: String) -> Texture:
	return data[id][0]["texture"]