import os
import cv2
import numpy as np
import os
from os.path import dirname, join

#storing mean_values,age & gender
MODEL_MEAN_VALUES = (78.4263377603, 87.7689143744, 114.895847746)
age_list = ['(0, 2)', '(4, 6)', '(8, 12)', '(15, 20)', '(25, 32)', '(38, 43)', '(48, 53)', '(60, 100)']
gender_list = ['Male', 'Female']

#read pre-trained neural network data from path to variables
protoPathAge = os.path.sep.join([r"PATH",  "deploy_age.prototxt"])
modelPathAge = os.path.sep.join([r"PATH","age_net.caffemodel"])

protoPathGender = os.path.sep.join([r"PATH",  "deploy_gender.prototxt"])
modelPathGender = os.path.sep.join([r"PATH","gender_net.caffemodel"])

#load neural network pre-trained models for detection
age_net = cv2.dnn.readNetFromCaffe(protoPathAge,modelPathAge)
gender_net = cv2.dnn.readNetFromCaffe(protoPathGender,modelPathGender)

#load pre-build model for face detection
face_cascade_path = os.path.sep.join([r"PATH",  "haarcascade_frontalface_default.xml"])
face_cascade = cv2.CascadeClassifier(face_cascade_path)

#read image from path
image = cv2.imread(r"PATH")

#convert image to grey
imgGray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
faces = face_cascade.detectMultiScale(imgGray, 1.2 , 4)

#for each identified face run algorithm to predict age & gender
for (x,y,w,h) in faces:
        cv2.rectangle(image, (x,y),(x+w,y+h),(0,0,255),2)
        
        imgFace = image[y:y+h,x:x+w].copy() # nurel network is only support for 3 chanel data
        blob = cv2.dnn.blobFromImage(imgFace, 1, (227, 227), MODEL_MEAN_VALUES, swapRB=False) 
        # Binary Large Object ---> blob
        
        #predict age
        age_net.setInput(blob)
        age_pred = age_net.forward()
        age = age_list[age_pred[0].argmax()]
        
        # predit gender
        gender_net.setInput(blob)
        gender_pred = gender_net.forward()
        gender = gender_list[gender_pred[0].argmax()]
        
        #display age,gender with the face
        full_text = age + " " + gender
        cv2.putText(image,full_text, (x,y) , cv2.FONT_HERSHEY_COMPLEX, 0.5, (255,0,0), 1)
    

image_edited = cv2.resize(image, (800, 800))      
cv2.imshow("Image" , image_edited)
cv2.waitKey(0)
cv2.destroyAllWindows()
