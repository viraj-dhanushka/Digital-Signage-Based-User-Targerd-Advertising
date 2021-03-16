# Project Name : Digital Signage Based User Targeted Advertising

[**Click here to visit our website**](https://viradhanus.github.io/Digital-Signage-Based-User-Targerd-Advertising/)



## INTRODUCTION

![image](https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/target.png)
Digital signage is one of the best platforms to play advertisements nowadays. The network of digital displays that are managed from a central position and shows dynamically changing content is known as digital advertising.

Main usage purposes of digital signage is for promoting products,attention grabbing content, public information systems etc. Digital advertising can be seen in many places like supermarkets, shopping malls, bus stations, clothing stores and restaurants. Advantages that come with this system are ability to deliver information to people,easy to reach a large number of crowds at once, display some attention grabbing content and reduced cost.

## PROBLEM
Most of the advertisements displayed in the digital screens are not relevant for the targeted audience. So,ninety percent of the advertisements displayed using the currently existing digital signages are not very effective. Also the provided digital signage solutions are expensive to afford for most of the SMEs(Small and Medium Enterprises). So overcoming these problems with an improved device for an affordable price will have a good market value.

## SOLUTION
To overcome this kind of issues our proposed solution consists of an upgraded version with additional hardware/software which can do User Targeted Advertising. Here our aim is while showing content that changes dynamically, when a particular crowd (male/female/group) is identified in front of the screens it will change the current content flow and show some relevant,interesting advertisement for the targeted audience that might catch their attention.

The buyer(shop owner) of the digital signage unit can upload their advertisements using the provided user authenticated mobile application. Also add some specific advertisements categorized by gender and age group. When a user in front is detected specific content will be visible to the targeted audience.

Our solution architecture mainly consists of three units. They are digital signage control unit , user detecting and analysing unit and the smart power supply unit.

## PROPOSED SYSTEM : METHODOLOGY 

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/Capture_architecture.png" alt="image_architecture" width="400" height="500" />

The system consists of raspberry pi 3 which will act as the heart of the system and flutter as the mobile application framework for the front end and firestore as the backend.

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/docs/assets/img/portfolio/thumbnails/flowchart_new.png" alt="image_architecture" width="600" height="460" /> 

In the processes of user targeting, the User Detecting and Analyzing Unit recognizes the person in front of it  as a male or female.  Then approximate the age of that person. If there are more than one people, the system recognizes all the people. Here to take the live camera feed to the system, Raspberry PI camera module is used and to predict the age and the gender pre-trained machine learning and deep learning models with OpenCV are used.  
 
The Digital display is connected to raspberry pi using HDMI and the User Detecting and Analyzing Unit is attached to the digital display. This  mainly consists of Raspberry PI camera module. OpenCV library is used since it consists of algorithms for easy face detection and gender & age classification.

For face detection a lightweight and speed machine learning  algorithm called Haar Cascades is used. Even Though there are more accurate methods such as  HOG + Linear SVM, Single Shot Detectors and deep learning-based face detectors, haar cascades classifier is used due to its ability to rapid object detection and its high speed. For gender and age predicting, a pre-trained deep learning model is used. (Caffe model trained by Levi and Hassner in 2015)

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/detect.jpg" alt="image_detect" width="650" height="350"/>

- Firebase is used as the web server as it provides a number of economical and flexible features. 
- Flutter is used as the mobile app framework where dart is used as the programming language since the same code base can be used to develop both android and ios applications.

#### App front end designs

<div id = "app_frontends_list1" style="margin-bottom: 3em;">
    <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/phoneAuth.jpg" align="left" width="220" height="440">
    </div>
   <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/google_sign.jpg" align="left" width="220" height="440">
        </div> 
 <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/set_up_profile.jpg" align="left" width="220" height="440">
        </div>
  <div class="inline-block">
        <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/drawer.jpg" align="left" width="220" height="440">
    </div>
</div>

<div id = "app_frontends_list2">
    <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/dashboard.jpg" align="left" width="220" height="440">
    </div>  
    <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/assets_one.jpg" align="left" width="220" height="440">
        </div> 
    <div class="inline-block">
           <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/assets_two.jpg" align="left" width="220" height="440">
       </div>
    <div class="inline-block">
        <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/app_front_end/smart_power.jpg" alt = "" width="220" height="440">
    </div>
</div>

#### Smart Power Supply Unit
As an additional improvement, a smart power supply unit which can control the digital screen is implemented.
The system consists of a Smart Power Supply Unit that can be controlled through the internet from anywhere. It connects through the mobile app and the shopkeepers can control the screen anytime they want. Here, MQTT which is a lightweight protocol is used to communicate with the nodeMCU that has been placed inside the Smart Power Supply Unit. Using publish/subscribe and using the MacAddresses for topics each device can be uniquely identified and publish on/off messages to the device to control the digital screen by switching the relay inside. 
Here is the hardware design implementation diagrams for the smart power supply unit

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Software/Smart%20Power%20Suppy%20Unit/Diagrams/overalldesign_spu.png" alt="image_overall_design" width="650" height="350"/>

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Software/Smart%20Power%20Suppy%20Unit/Diagrams/hardwareimplementation_spu.jpg" alt="image_hardware_design" width="650" height="350"/>

#### Testing units
Multiple tests have driven to ensure the accurate functionality of the product. A detailed summary is provided in the webpage. A brief explaination about some of the validations and optimization through tests are as below
  * Check face detection and age/gender predicton accuracy when multiple people detected in a frame 
  * User entry validations for invalid form fills in login and profile pages  
  * Validating each users MacAddresses from firestore retrieve.
  * Devices add/drop functionality and drop down menu in app syncing with firestore collections
  * Subscribing to specific MacAddress topic and reconnecting in wifi failure with last published message status capturing

#### Bill of materials

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/bill_of_materials.png" alt="image_overall_design" width="650" height="350"/>
