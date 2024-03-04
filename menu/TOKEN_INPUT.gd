extends LineEdit

@onready var http_request = $HTTPRequest
var URL = "http://localhost:9000"
var path = "/game/activity/"
var response_data = {}


func _on_text_submitted(new_text):
	# HTTP Request should be sent with a JWT token
	var jwt_activity = "1"
	var final_path = path + jwt_activity + "/question"
	
	http_request.request(URL + final_path)


func _on_http_request_request_completed(result, response_code, headers, body):

	# UTF-8 encoded response body from /activity/:activity_id/question
	response_data = JSON.parse_string(body.get_string_from_utf8())
	
	# Handle error
	if response_code >= 400:
		# SHOW ERROR MESSAGE IN $TOKEN_INPUT/Label 
		var msg = "Invalid Token.."
		# abort function
		return
	

	for x in range(response_data.data.size()):
		# Change xxx.choices type from JSON.string to Array
		response_data.data[x].choices = JSON.parse_string(response_data.data[x].choices)
		
		# Store response data in questions_store
		Global.questions_store = response_data.data
	
	# IF Token is valid proceed to main scene
	get_tree().change_scene_to_file("res://main.tscn")
	
	
