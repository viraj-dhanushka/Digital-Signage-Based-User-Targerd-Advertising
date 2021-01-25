
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiManager.h>
#include <DNSServer.h>
#include <ESP8266WebServer.h>


const char* mqtt_server = "broker.emqx.io";         // MQTT broker


WiFiManager wifiManager;
WiFiClient espClient;
PubSubClient client(espClient);

//long lastMsg = 0;    // no use, remove
//char msg[50];        // no use, remove
//int value = 0;       // no use, remove

String mac_add = "";
char mac_address[50] = "test1/";

/* ============================---connect to WiFi----=============================== */
void setup_wifi() {

  delay(100);

  Serial.println();
  Serial.print("Connecting to ");

  wifiManager.autoConnect("Power Supply", "12345678");    // make the local network, if previous network is not available

  randomSeed(micros());                                   // make a random seed
  
 
  /* ======== convert string ---> char array ===========*/
  // 
  mac_add = WiFi.macAddress();
  int i = 0;
  for (i = 0; i < 50; i++) {
    mac_address[i] = mac_add[i];
  }
  /* ===================================================*/



  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println(mac_add);
}
/*====================================================================================*/

/*==================================--- call back--- =================================*/
void callback(char* topic, byte* payload, unsigned int length) {

  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  String s = "";

  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
    s = s + (char)payload[i];
  }

  int in = s.toInt();

  switch (in)
  {
    case 1:                               // make bultin led ON
      digitalWrite(13, HIGH);
      break;
    case 0:                               // make bultin led ON
      digitalWrite(13, LOW);
      break;
  }
}

/*=====================================================================================*/


/*=================================--- reconnect ---===================================*/
void reconnect() {

  while (!client.connected()) {                     // Loop until we're reconnected                  
  

    Serial.print("Attempting MQTT connection...");
    
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);

    // Attempt to connect
    if (client.connect(clientId.c_str())) {         // c_str gives A pointer to the C-style version of the invoking String
      Serial.println("connected");
      client.subscribe(mac_address);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");

      // Wait 5 seconds before retrying
      int count = 0;
      while (count <= 5)                           // if WiFi is not avilaible
      {
        digitalWrite(4, HIGH);                     // blink the green LED
        delay(500);
        digitalWrite(4, LOW);
        delay(500);
        count++;
      }
    }
  }

  digitalWrite(4, LOW);                            // turn on the green LRD when WiFi is avalible
}

/*======================================================================================*/

/*==============================--- setup ---===========================================*/
void setup() {
  pinMode(13, OUTPUT);                            // Configure Pin 13 (D7) as as Output
  pinMode(4, OUTPUT);                             // Configure Pin 13 (D2) as as Output
  digitalWrite(13, LOW);                          // turn off the socket at the begening
  int count = 0;

  Serial.begin(115200);

  while (count <= 5)                              // if WiFi is not avilaible
  {
    digitalWrite(4, HIGH);                        // blink the green LED
    delay(500);
    digitalWrite(4, LOW);
    delay(500);
    count++;
  }

  //wifiManager.resetSettings();

  setup_wifi();                                  // setup the WiFi connection

  client.setServer(mqtt_server, 1883);           // set the mqtt server
  client.setCallback(callback);                  // set the callback function
}

/*======================================================================================*/


/*====================================--- loop ---======================================*/
void loop() {

  if (!client.connected()) {                    // if MQTT is disconnected re-connect using 
    reconnect();                                //  reconnect() function                    
  }

  client.loop();

}
/*=====================================================================================*/
