import requests

params = {'text': '吾輩はヌッコである。', 'dictionary': 'ipadic', 'args': '-f 3'}

response = requests.get(
    'http://127.0.0.1:8000/cabocha',
    headers={'accept': 'application/json'},
    params=params,
)

result = response.json()
print(result.get('result'))
