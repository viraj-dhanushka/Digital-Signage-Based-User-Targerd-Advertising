"""
Should you add any of the encoding to the top of this file?
https://docs.python.org/3/tutorial/interpreter.html#source-code-encoding
You can erase this after you decide this.
"""

#simple python programme to list assets
import requests

ip = input("Enter your ip: ")
# ip = "192.168.1.101"


import requests
headers = {
    "Authorization": "Token {token}",
    "Content-Type": "application/json"
}
response = requests.request(
    method='GET',
    url='http://' + ip + '/api/v1.2/assets',
    headers=headers
)
print(response.json())
