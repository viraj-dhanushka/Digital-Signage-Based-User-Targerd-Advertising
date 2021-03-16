### This file contains data about the commands that we are using to communicate with Screenly API
---

- HTTP authentication should be set on the Raspberry Pi / Screenly OSE device when deploying publicly
- Decide which method will be used for changing assets (via YML files or CURL commands)
  - YML files are easier to prepare and fill with assets, but require figuring out how to activate remotely
  - CURL commands are harder to prepare but once you use a template you can fill them up and prepare them fairly easy
- Preloading wpa_supplicant.conf files for deploying at known locations with known WiFi network info

#### This is an example of disabling an asset that we know the asset_id for:
```
curl -X PATCH "http://192.168.1.8/api/v1.2/assets/0ef41b93f855433ca87a9f52b763c50f" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"is_enabled\": 0}"
```
We use the `is_enabled: 0` to tell the asset to become inactive/disabled.


#### switch to next asset and start loop in case old asset plays for long time
```
curl -X GET "http://192.168.1.8/api/v1/assets/control/next"
```

We would need to use this at the end of a set of commands after adding multiple assets via CURL so that if the asset being played when the command is sent is currently not finished and the playlist has not been generated, it advances the playlist manually.

#### The following is an example of a command that creates an asset remotely via curl command
```
curl -X POST "http://192.168.1.10/api/v1.2/assets" -H  "accept: application/json" -H  "content-type: application/json" -d "{  \"mimetype\": \"webpage\",  \"is_enabled\": 1,  \"name\": \"weather screenly io\",  \"end_date\": \"2021-11-17T07:37:28.486Z\",  \"duration\": \"30\",  \"uri\": \"https://weather.srly.io?lang=en&24h=0&wind_speed=0\",  \"skip_asset_check\": 1,  \"start_date\": \"2020-11-17T07:37:28.486Z\"}"
```

#### The following is an example of what the asset contains in its json data:
```
Asset Array: 0
Asset ID: 0ef41b93f855433ca87a9f52b763c50f
Asset Name: weather-screenly-io
Asset URL: https://weather.srly.io?lang=en&24h=0&wind_speed=0
Asset Enabled: 1
Asset Type: webpage
Asset Start Date: 2020-10-29T18:33:00+00:00
Asset End Date: 2021-11-28T19:33:00+00:00
Asset Duration: 25
```

---
### To send CURL commands to API when HTTP authentication is set

We will use the following example command and can prepare the username and password:
`curl -k --anyauth --user admin:password -X GET "http://192.168.1.10/api/v1.2/assets" -H  "accept: application/json"`

The `-k` parameter allows for HTTPS/SSL connections without certificates.  
The `--anyauth` parameter allows for any type of authentication that the server has set on its end.  
The `--user admin:password` parameter needs to be edited for the specific RPi device that will be contacted.  

---
#### This section of python code is what the server.py file uses to enable the default assets that are prepared in the default_assets.yml file

For each target (male, female, child), we would need to create separate YML files for each target and fill each with the appropriate information.
Adding URLs is straightforward, but for images and videos we have to upload them to the device prior to the assets being created on the database, and then you have to test to make sure that the location uri is properly referencing the file.
```
def prepare_default_asset(**kwargs):
    if kwargs['mimetype'] not in ['image', 'video', 'webpage']:
        return

    asset_id = 'default_{}'.format(uuid.uuid4().hex)
    duration = int(get_video_duration(kwargs['uri']).total_seconds()) if "video" == kwargs['mimetype'] else kwargs['duration']

    return {
        'asset_id': asset_id,
        'duration': duration,
        'end_date': kwargs['end_date'],
        'is_active': 1,
        'is_enabled': True,
        'is_processing': 0,
        'mimetype': kwargs['mimetype'],
        'name': kwargs['name'],
        'nocache': 0,
        'play_order': 0,
        'skip_asset_check': 0,
        'start_date': kwargs['start_date'],
        'uri': kwargs['uri']
    }


def add_default_assets():
    settings.load()

    datetime_now = datetime.now()
    default_asset_settings = {
        'start_date': datetime_now,
        'end_date': datetime_now.replace(year=datetime_now.year + 6),
        'duration': settings['default_duration']
    }

    default_assets_yaml = path.join(HOME, '.screenly/default_assets.yml')

    with open(default_assets_yaml, 'r') as yaml_file:
        default_assets = yaml.safe_load(yaml_file).get('assets')
        with db.conn(settings['database']) as conn:
            for default_asset in default_assets:
                default_asset_settings.update({
                    'name': default_asset.get('name'),
                    'uri': default_asset.get('uri'),
                    'mimetype': default_asset.get('mimetype')
                })
                asset = prepare_default_asset(**default_asset_settings)
                if asset:
                    assets_helper.create(conn, asset)


def remove_default_assets():
    settings.load()
    with db.conn(settings['database']) as conn:
        for asset in assets_helper.read(conn):
            if asset['asset_id'].startswith('default_'):
                assets_helper.delete(conn, asset['asset_id'])
```

#### This is the example of default_assets.yml file:
```
pi@screenlypi4:~ $ cat ./.screenly/default_assets.yml 
assets:
  - name: Screenly Weather Widget
    uri: https://weather.srly.io
    mimetype: webpage

  - name: Screenly Clock Widget
    uri: https://clock.srly.io
    mimetype: webpage

  - name: Hacker News
    uri: https://news.ycombinator.com
    mimetype: webpage
```
---
#### This is how we prepare a wpa_supplicant.conf file for deploying device preloaded with WiFi settings

Use a website that calculates WPA pre-shared keys, such as `https://www.wireshark.org/tools/wpa-psk.html`
As an example, we have SSID called VIRAJ, and password Password123.
After we input these values into that generator form, the psk-key value is: `dbedc6954827ad7187466e42f4df78d9108955778959b5db11920f8c328dd716`
We take this value and create a file called `wpa_supplicant.conf` and fill it with the following contents:
```
country=LK
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
ssid="VIRAJ"
psk=dbedc6954827ad7187466e42f4df78d9108955778959b5db11920f8c328dd716
}
```

Then, we save that file inside the Raspberry Pi SD card in the `/boot/` volume, so it will be `/boot/wpa_supplicant.conf`.
More info on this can be read here: `https://www.raspberrypi.org/documentation/configuration/wireless/headless.md`
and also here: `https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md`
