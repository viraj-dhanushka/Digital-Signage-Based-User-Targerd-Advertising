#!/bin/bash

set -x
# global variables
API_URL='https://192.168.43.219/api/v1/assets'
H_ACCEPT='accept: application/json'
H_TYPE='content-type: application/json'

EN_REQ='is_enabled": "1",
	"mimetype": "webpage",
	"start_date": "2020-01-01T00:00:00.000Z",
	"end_date": "9999-01-01T00:00:00.000Z",
	"duration": "60",
	"skip_asset_check": "1'

DISS_REQ='is_enabled": "0",
	"mimetype": "webpage",
	"start_date": "2020-01-01T00:00:00.000Z",
	"end_date": "9999-01-01T00:00:00.000Z",
	"duration": "60",
	"skip_asset_check": "1'

# disable assets

function female_25_32() {
cat <<EOF
	{
	"asset_id": "female_25_32",
	"name": "female_25_32",
	"uri": "https://st4.depositphotos.com/5934840/20883/v/600/depositphotos_208839300-stock-video-executive-business-woman-cartoon-hd.jpg",
	"${DISS_REQ}"
	}
EOF
}

function generic() {
cat <<EOF
	{
	"asset_id": "generic",
	"name": "generic",
	"uri": "https://static.vecteezy.com/system/resources/previews/000/082/319/non_2x/group-of-people-vector.jpg",
	"${DISS_REQ}"
}
EOF
}
# enable ads
function male_25_32() {
cat <<EOF
	{
	"asset_id": "male_25_32",
	"name": "male_25_32",
	"uri": "https://ak.picdn.net/shutterstock/videos/23326564/thumb/1.jpg?ip=x480",
	"${EN_REQ}"
	}
EOF
}

# dissable assets
curl -s -k -X PUT "${API_URL}/female_25_32" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(female_25_32)"; # -k or --insecure 
curl -s -k -X PUT "${API_URL}/generic" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(generic)"; # -k or --insecure 

# enable assets
curl -s -k -X PUT "${API_URL}/male_25_32" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(male_25_32)"; # -k or --insecure 

# restart asset playlist
curl -k -X GET "https://192.168.43.219/api/v1/assets/control/previous" -H  "accept: application/json";

#end