# User Targeted Advertising

[**Click here to visit our website**](https://cepdnaclk.github.io/e16-3yp-digital-signage-based-user-targeted-advertising/)



##  Introduction

User Targeted Advertising folder mainly contains two jupyter notebook files which are Age_and_Gender_detecting_images.ipynb and Age_and_Gender_detecting_webCam.ipynb . 
Both of these codes are implemented with the use of trained data model developed using deep neural network models.(age_net.caffemodel and gender_net.caffemodel) and 
Caffe framework is used to train the data sets.

[Reference link for Trained data model](https://talhassner.github.io/home/publication/2015_CVPR)
   
 - Age_and_Gender_detecting_images.ipynb
    \
    Prediction can be tested for images saved in sample_photos folder.
    
 - Age_and_Gender_detecting_webCam.ipynb
   \
  Prediction is done by capturing the video using the webcam. This is the real scenario happening in our project.
  
  To detect faces from images and webcam opencv libraries such as haarcascade,dnn package (to import neural network trained models) are used to predict gender and age.
  
 [Reference link for opencv libraries](https://github.com/opencv/opencv)
 
## How To Run The Application.

We can run the two jupytor files in the same way.

To run the above two applications, above folder and referenced links provide the trained model,datasets and opencv packages. You should have below files to run the code.
 - jupytor notebook file
 - gender_net.caffemodel
 - age_net.caffemodel
 - haarcascade folder
 - deploy_age.prototxt
 - deploy_gender.prototxt
 
You have to add paths from your local directory after putting above files in a folder. These changes need to be done for both jupytor files.

 - <b>Give correct path for the caffe models and prototxt files changing below 4 lines of code</b>
   
   <pre>protoPathage = os.path.sep.join([r"PATH to the folder where deploy_age.prototxt is in",  "deploy_age.prototxt"])
   
   modelPathage = os.path.sep.join([r"PATH to the folder where age_net.caffemodel is in","age_net.caffemodel"])

   protoPathgender = os.path.sep.join([r"PATH to the folder where deploy_gender.prototxt  is in",  "deploy_gender.prototxt"])
   
   modelPathgender = os.path.sep.join([r"PATH to the folder where gender net.caffemodel is in","gender_net.caffemodel"])
   </pre>


 - <b>To load the pre-built model for facial detection, edit below line of code.</b>
 
   <pre>face_cascade_path = os.path.sep.join([r"PATH to haarcascade code",  "haarcascade_frontalface_default.xml"])</pre>
   
 - <b>If you are running Age and Gender detection for Images.ipynb edit below line of code to add the path to the sample image. </b>
  
   <pre>image = cv2.imread(r"PATH to sample image")<pre>
   
  By doing these changes you can successfully run the application. Make sure you have installed anaconda navigator , opencv and numpy libraries.
   




