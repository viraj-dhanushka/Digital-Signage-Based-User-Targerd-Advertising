#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#simple python programme to list assets
import requests
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
# ip = input("Enter your ip: ")
ip = "192.168.43.219"


import requests
headers = {
    # "Authorization": "Token {token}",
    "accept": "application/json",
    "Content-Type": "application/json"
}
# response = requests.request(
#     method='GET',
#     url='http://' + ip + '/api/v1.2/assets',
#     # headers=headers
# )
response = requests.get(
    'https://' + ip + '/api/v1.2/assets', verify=False,
    headers=headers,
)
# response = requests.post(
#     'http://' + ip + '/api/v1.2/assets', 
#     headers={'Accept': 'application/json','content-type': 'application/json'},
#     verify=False,
#     data={'asset_id': 'c6975dca120146b9bd1a78d63c50d570', 'mimetype': 'webpage', 'name': 'Hacker News', 'end_date': '2027-01-14T07:52:13.308465+00:00', 'is_enabled': 1, 'nocache': 0, 'is_active': 1, 'uri': 'https://news.ycombinator.com', 'skip_asset_check': 0, 'duration': '10', 'play_order': 2, 'start_date': '2021-01-14T07:52:13.308465+00:00', 'is_processing': 0}
# )
print(response.json())
