#!/bin/bash

set -x
# global variables
API_URL='https://192.168.43.219/api/v1/assets'
H_ACCEPT='accept: application/json'
H_TYPE='content-type: application/json'

ALL_REQ='is_enabled": "1",
	"mimetype": "webpage",
	"start_date": "2020-01-01T00:00:00.000Z",
	"end_date": "9999-01-01T00:00:00.000Z",
	"duration": "10",
	"skip_asset_check": "1'


function female_25_32() {
cat <<EOF
	{
	"asset_id": "female_25_32",
	"name": "female_25_32",
	"uri": "https://docs.google.com/presentation/d/e/2PACX-1vQSfEVaOqFgEW3dI1A6mcAMeWv6IWRlgEssaTYSBJ3F-aVEouapLdUCLK-rdcHAp5hkswqSDmZqenCG/pub?start=true&loop=true&delayms=3000",
	"${ALL_REQ}"
	}
EOF
}

# create assets
curl -s -k -X POST "${API_URL}" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(female_25_32)"; # -k or --insecure 

# restart asset playlist
curl -k -X GET "https://192.168.43.219/api/v1/assets/control/previous" -H  "accept: application/json";

#end