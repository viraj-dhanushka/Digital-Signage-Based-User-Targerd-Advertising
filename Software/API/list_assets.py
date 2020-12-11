#!/usr/bin/env python3
# -*- coding: cp1252 -*-

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
