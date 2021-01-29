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


function generic_ads() {
cat <<EOF
	{
	"asset_id": "generic_ads",
	"name": "generic_ads",
	"uri": "https://docs.google.com/presentation/d/e/2PACX-1vT_jiaWYIqNXIomiqOHcT3mERf-lxJsin-Q4tOK4bxejttQ190wiQCcbdEcSSw7YyNzbOrAlCaaM7Sm/pub?start=true&loop=true&delayms=3000",
	"${ALL_REQ}"
	}
EOF
}

# create assets
curl -s -k -X POST "${API_URL}" -H "${H_ACCEPT}" -H "${H_TYPE}" -d "$(generic_ads)"; # -k or --insecure 

# restart asset playlist
curl -k -X GET "https://192.168.43.219/api/v1/assets/control/previous" -H  "accept: application/json";

#end