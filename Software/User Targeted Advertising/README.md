# User Targeted Advertising

[**Click here to visit our website**](https://cepdnaclk.github.io/e16-3yp-digital-signage-based-user-targeted-advertising/)


##  Introduction

User Targeted Advertising folder contains python code files age_gender_detection_Images.py and age_gender_detection_webCam.py for running the age and gender detection for both images and webCam feed. For developing the code we used jupyter notebook as it provides better features for debugging and testing. jupyter_codes folder contain these files.

Both of these codes are implemented with the use of trained data model developed using deep neural network models.(age_net.caffemodel and gender_net.caffemodel) and 
Caffe framework is used to train the data sets. 

[Reference link for Trained data model](https://talhassner.github.io/home/publication/2015_CVPR)
   
 - age_gender_detection_Images.py
    \
    Prediction can be tested for images saved in sample_photos folder.
    
 - age_gender_detection_webCam.py
   \
  Prediction is done by capturing the video using the webcam. This is the real scenario happening in our project.
  
  To detect faces from images,webcam and to import neural network trained models, opencv libraries such as haarcascade,dnn packages are used in the code for predicting gender and age.
  
 [Reference link for opencv libraries](https://github.com/opencv/opencv)
 
## How To Run The Application.

To run the above two applications, above folder and referenced links provide the trained model,datasets and opencv packages. You should have below files to run the code.
 - gender_net.caffemodel
 - age_net.caffemodel
 - haarcascade folder
 - deploy_age.prototxt
 - deploy_gender.prototxt
 
You have to add PATHs to above files in the code from your local directory after putting in a folder.
   
By doing these changes you can successfully run the application. Make sure you have installed opencv and numpy libraries.
   
