import requests

# Base URL of the Django backend server
BASE_URL = "http://127.0.0.1:8000/api"

def test_get_courses():
    url = f"{BASE_URL}/courses/"
    response = requests.get(url)
    if response.status_code == 200:
        print("GET /api/courses/ - Success")
        print("Response:", response.json())
    else:
        print("GET /api/courses/ - Failed")
        print("Status Code:", response.status_code)

def test_get_sentences():
    url = f"{BASE_URL}/sentences/"
    response = requests.get(url)
    if response.status_code == 200:
        print("GET /api/sentences/ - Success")
        print("Response:", response.json())
    else:
        print("GET /api/sentences/ - Failed")
        print("Status Code:", response.status_code)

if __name__ == "__main__":
    print("Testing API endpoints:")
    test_get_courses()
    test_get_sentences()
