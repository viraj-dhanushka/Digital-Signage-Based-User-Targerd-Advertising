#!/bin/bash
#ealmonte32

set -x

# global variables
API_URL='http://192.168.1.8/api/v1.2/assets'
H_ACCEPT='accept: application/json'
H_TYPE='content-type: application/json'

ALL_REQ='is_enabled": "1",
	"mimetype": "webpage",
	"start_date": "2020-01-01T00:00:00.000Z",
	"end_date": "9999-01-01T00:00:00.000Z",
	"duration": "15",
	"skip_asset_check": "1'

# loop through array contents to gather all current asset_id's


# disable all assets in the current array


# male assets
function male_ad1() {
cat <<EOF
	{
	"asset_id": "male_ad1",
	"name": "male_ad1",
	"uri": "https://i.pinimg.com/originals/8a/c0/4f/8ac04fb2af0efb66e07641f4dd335c4f.jpg",
	"${ALL_REQ}"
	}
EOF
}

function male_ad2() {
cat <<EOF
	{
	"asset_id": "male_ad2",
	"name": "male_ad2",
	"uri": "https://www.thetrendspotter.net/wp-content/uploads/2017/01/Best-Clothing-Stores-men.jpg",
	"${ALL_REQ}"
}
EOF
}

function male_ad3() {
cat <<EOF
	{
	"asset_id": "male_ad3",
	"name": "male_ad3",
	"uri": "https://www.telegraph.co.uk/content/dam/men/2018/07/02/TELEMMGLPICT000168190077_trans_NvBQzQNjv4BqpVlberWd9EgFPZtcLiMQfyf2A9a6I9YchsjMeADBa08.jpeg",
	"${ALL_REQ}"
}
EOF
}

# create assets
curl -s -X POST "${API_URL}" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(male_ad1)";
curl -s -X POST "${API_URL}" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(male_ad2)";
curl -s -X POST "${API_URL}" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(male_ad3)";

# restart asset playlist
curl -X GET "http://192.168.1.8/api/v1/assets/control/previous" -H  "accept: application/json";

#end
