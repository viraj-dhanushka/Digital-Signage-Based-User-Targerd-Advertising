#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#simple python programme to list assets
import requests
import urllib3
# urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
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

# response = requests.post(
#     'http://' + ip + '/api/v1/assets', 
#     headers={'Accept': 'application/json','content-type': 'application/json'},
#     verify=False,
#     data={'asset_id': 'c6975dca120146b9bd1a78d63c50d570', 'mimetype': 'webpage', 'name': 'Hacker News', 'end_date': '2027-03-14T07:52:13.308465+00:00', 'is_enabled': 1, 'nocache': 0, 'is_active': 1, 'uri': 'https://news.ycombinator.com', 'skip_asset_check': 0, 'duration': '10', 'play_order': 2, 'start_date': '2021-01-14T07:52:13.308465+00:00', 'is_processing': 0}
# )
assets_list = []
assets_list.append(
    {'asset_id': 'male_ad4', 'mimetype': 'webpage', 'name': 'male_ad4', 'end_date': '9999-01-01T00:00:00+00:00', 'is_enabled': 1, 'nocache': '', 'is_active': 1, 'uri': 'https://www.thetrendspotter.net/wp-content/uploads/2017/01/Best-Clothing-Stores-men.jpg', 'skip_asset_check': 1, 'duration': '15', 'play_order': 1, 'start_date': '2020-01-01T00:00:00+00:00', 'is_processing': ''}
)
response = requests(
    method='POST',
    url='https://' + ip + '/api/v1/assets/',
    verify=False,
    data = {"mimetype": "webpage", "asset_id": "male_ad3", "end_date": "9999-01-01T00:00:00+00:00", "name": "male_ad3", "nocache": "", "is_enabled": "1", "is_active": 1, "uri": "https://www.telegraph.co.uk/content/dam/men/2018/07/02/TELEMMGLPICT000168190077_trans_NvBQzQNjv4BqpVlberWd9EgFPZtcLiMQfyf2A9a6I9YchsjMeADBa08.jpeg", "start_date": "2020-01-01T00:00:00+00:00", "duration": 15, "skip_asset_check": 1, "is_processing": ""},
    # data={'asset_id': 'male_ad4', 'mimetype': 'webpage', 'name': 'male_ad4', 'end_date': '9999-01-01T00:00:00+00:00', 'is_enabled': 1, 'nocache': '', 'is_active': 1, 'uri': 'https://www.thetrendspotter.net/wp-content/uploads/2017/01/Best-Clothing-Stores-men.jpg', 'skip_asset_check': 1, 'duration': '15', 'play_order': 1, 'start_date': '2020-01-01T00:00:00+00:00', 'is_processing': '0'},
    # headers={
    #             # "Authorization": "Token {token}",
    #             "accept": "application/json",
    #             "content-Type": "application/json"
    #         }
)
print(response.json())

# response = requests.request(
#     method='GET',
#     url='https://' + ip + '/api/v1/assets',
#     verify=False,
#     headers=headers
# )
# print(response.json())

# response1 = requests.put(
#     'https://' + ip + '/api/v1/assets/', verify=False,
#     json=assets_list,
#     headers=headers,

# )
# response = requests.get(
#     'https://' + ip + '/api/v1/assets', verify=False,
#     headers=headers,
# )

# print(response.json())
