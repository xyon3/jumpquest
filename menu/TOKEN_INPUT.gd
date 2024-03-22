extends LineEdit

@onready var http_request = $HTTPRequest

#@onready var ca_cert = load("res://minica.crt")
var URL = ""
#var URL = "https://php:9000"
#var path = "/api/question/actions/lng.retrieve.php/?e=LNG-PTA02-1"
var path = "/game/activity/"
var response_data = {}

func _on_text_submitted(new_text):
	# HTTP Request should be sent with a JWT token
	
	var b = JSON.parse_string(Marshalls.base64_to_utf8(new_text))
	
	if b:
		URL = "https://"+b["host"]+":9001"
		
		var jwt_activity = "1"
		var final_path = path + jwt_activity + "/question"
		print(URL + final_path)
		
		http_request.request(URL + final_path)
	pass


func _on_http_request_request_completed(result, response_code, headers, body):


	
	# Handle error
	if response_code >= 400:
		# SHOW ERROR MESSAGE IN $TOKEN_INPUT/Label 
		var msg = "Invalid Token.."
		# abort function
		return
	
	# UTF-8 encoded response body from /activity/:activity_id/question
	response_data = JSON.parse_string(body.get_string_from_utf8())


	for x in range(response_data.data.size()):
		# Change xxx.choices type from JSON.string to Array
		response_data.data[x].choices = JSON.parse_string(response_data.data[x].choices)
		
		# Store response data in questions_store
		Global.questions_store = response_data.data
		
	#print(Global.questions_store)
	Global.questions_store = [
  {
	"id": "MUL-MCQ01-1",
	"text": "Which of the following is a factor of the polynomial 2x^2 + 4x?",
	"correct_answer": "A) x + 2",
	"choices": [
	  "A) x + 2",
	  "B) x - 1",
	  "C) 2x + 3",
	  "D) 3x"
	]
  },
  {
	"id": "MUL-MCQ01-2",
	"text": "What is a mathematical statement that indicates the relationship between two quantities, where one is greater than, less than, or equal to the other?",
	"correct_answer": "C) Inequality",
	"choices": [
	  "A) Polynomial",
	  "B) Equation",
	  "C) Inequality",
	  "D) Expression"
	]
  },
  {
	"id": "MUL-MCQ01-3",
	"text": "Which of the following is a linear equation in two variables?",
	"correct_answer": "B) 2x + 3y = 6",
	"choices": [
	  "A) y = 3x^2 + 2",
	  "B) 2x + 3y = 6",
	  "C) y = 1/x",
	  "D) 4x^2 + 5y = 10"
	]
  },
  {
	"id": "MUL-MCQ01-4",
	"text": "What is a mathematical sentence stating that two expressions are equal?",
	"correct_answer": "B) Equation",
	"choices": [
	  "A) Polynomial",
	  "B) Equation",
	  "C) Inequality",
	  "D) Variable"
	]
  },
  {
	"id": "MUL-MCQ01-5",
	"text": "What is the solution to the linear equation 3x - 5 = 10?",
	"correct_answer": "B) x = 5",
	"choices": [
	  "A) x = 15",
	  "B) x = 5",
	  "C) x = 3.33",
	  "D) x = -5"
	]
  }
]

	
	# IF Token is valid proceed to main scene
	get_tree().change_scene_to_file("res://main.tscn")
	
	
