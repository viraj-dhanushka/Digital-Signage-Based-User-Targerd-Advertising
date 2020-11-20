# Project Name : Digital Signage Based User Targeted Advertising

[**Click here to visit our website**](https://cepdnaclk.github.io/e16-3yp-digital-signage-based-user-targeted-advertising/)

#### Group Members : 
  * Dhanushka S.M.V. &nbsp;&nbsp;&nbsp; E/16/083 &nbsp;&nbsp;&nbsp;e16083@eng.pdn.ac.lk
  * Lakmali B.L.S. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; E/16/200  &nbsp;&nbsp;&nbsp;&nbsp;e16200@eng.pdn.ac.lk
  * Thisanke M.K.H.   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; E/16/368 &nbsp;&nbsp;&nbsp;&nbsp;e16368@eng.pdn.ac.lk
                           
<div id="Members" >
    <div class="inline-block">
        <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/Member1.jpg" align="left" width="250" height="250">
    </div>
    <div class="inline-block">
        <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/Member2.jpg" align="left" width="250" height="250">
    </div>
    <div class="inline-block">
       <img src ="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/Member3.jpg" alt= " "  width="230" height="250">
    </div>
</div>

## INTRODUCTION

![image](https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/target.png)
Digital signage is one of the best platforms to play advertisements nowadays. The network of digital displays that are managed from a central position and shows dynamically changing content is known as digital advertising.

Main usage purposes of digital signage is for promoting products,attention grabbing content, public information systems etc. Digital advertising can be seen in many places like supermarkets, shopping malls, bus stations, clothing stores and restaurants. Advantages that come with this system are ability to deliver information to people,easy to reach a large number of crowds at once, display some attention grabbing content and reduced cost.

## PROBLEM
Most of the advertisements displayed in the digital screens are not relevant for the targeted audience. So,ninety percent of the advertisements displayed using the currently existing digital signages are not very effective. Also the provided digital signage solutions are expensive to afford for most of the SMEs(Small and Medium Enterprises). So overcoming these problems with an improved device for an affordable price will have a good market value.

## SOLUTION
To overcome this kind of issues our proposed solution consists of an upgraded version with additional hardware/software which can do User Targeted Advertising. Here our aim is while showing content that changes dynamically, when a particular crowd (male/female/children) is identified in front of the screens it will change the current content flow and show some relevant,interesting advertisement for the targeted audience that might catch their attention.

The buyer(shop owner) of the digital signage unit can upload their advertisements using the provided user authenticated web application or the mobile application. Also add some specific advertisements categorized by gender and age group. When a user in front is detected specific content will be visible to the targeted audience.

Our solution architecture mainly consists of three units. They are digital signage control unit , user detecting and analysing unit and the smart power supply unit.

## PROPOSED SYSTEM : METHODOLOGY 

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/Capture_architecture.PNG" alt="image_architecture" width="400" height="500" />

- The system consists of raspberry pi 3 which will act as the heart of the system and mainly django as the web application framework for the front end as well as for the backend. 
- The Digital display is connected to raspberry pi using HDMI and the user detecting and analyzing unit is attached to the digital display. This user detecting and analyzing unit mainly consists of Raspberry PI camera module and distance sensor module. OpenCV library is used since it consists of algorithems for easy face detection and gender & age classification.

<img src="https://github.com/cepdnaclk/e16-3yp-digital-signage-based-user-targeted-advertising/blob/main/Images/detect.jpg" alt="image_detect" width="650" height="350"/>

- AWS is used as the web server as it provides a number of economical and flexible features. 
- Flutter is used as the mobile app framework where dart is used as the programming language since the same code base can be used to develop both android and ios applications.
- As an additional improvement, a power supply unit which can control the digital screen on/off through the web application will be implemented.

## Advisors

>Dr. Isuru Nawinne

>Mr. Ziyan Maraikar

##### Links:
> [Department of Computer Engineering Website](http://www.ce.pdn.ac.lk/) 

> [Faculty of Engineering Website](https://eng.pdn.ac.lk/) 

> [University of Peradeniya Website](https://www.pdn.ac.lk/)



