extends LineEdit

@onready var http_request = $HTTPRequest
var URL = "http://localhost:9000"
var path = "/game/"

func _on_text_submitted(new_text):
	http_request.request(URL + path)

func _on_http_request_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	get_tree().change_scene_to_file("res://main.tscn")
	
	
	# IF Token is valid proceed to main scene
