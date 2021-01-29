#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# import getmac
import os
import cv2
import numpy as np

import threading
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import time


MODEL_MEAN_VALUES = (78.4263377603, 87.7689143744, 114.895847746)
age_list = ['(0,2)', '(4,6)', '(8,12)', '(15,20)', '(25,32)', '(38,43)', '(48,53)', '(60,100)']
gender_list = ['male', 'female']

age_net = cv2.dnn.readNetFromCaffe('/home/viraj/Desktop/abc/deploy_age.prototxt', '/home/viraj/Desktop/abc/age_net.caffemodel')
gender_net = cv2.dnn.readNetFromCaffe('/home/viraj/Desktop/abc/deploy_gender.prototxt', '/home/viraj/Desktop/abc/gender_net.caffemodel')

face_cascade = cv2.CascadeClassifier("/home/viraj/Desktop/abc/haarcascade_frontalface_default.xml")




# Use a service account
cred = credentials.Certificate('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/flashapp-7027e-firebase-adminsdk-fz2rt-714ca34e83.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

#dictionaries to hold ads
male_ads_dict = {}
female_ads_dict = {}
generic_ads_dict = {}

# macAddr = getmac.get_mac_address()
macAddr = u'b8:27:eb:88:85:92'

rpi_ref = db.collection(u'signage units').document(macAddr)
customer_ref = rpi_ref.collection(u'customers').document(u'analysis')

rpi_mac = rpi_ref.get()
if rpi_mac.exists: 
    print("device exists")
else:
    rpi_ref.set({
        u'isUserTargeting':False,
    })


# Create an Event for notifying main thread.
callback_done = threading.Event()

# Create a callback on_snapshot function to capture changes
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        adStates_dict = doc.to_dict()

        if adStates_dict["isUserTargeting"]:
            print("do targetting")
            showAd(adStates_dict["ad_type"],adStates_dict["ad_age"])
        else:
            #delete all slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    callback_done.set()

# Watch the document
doc_watch = rpi_ref.on_snapshot(on_snapshot)    

#function to show ad from firestore
def showAd(adType,adAge):

    if adType == 'male':
        if adAge == '(25,32)':
            #delete all slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
            #create slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/male_slides_2532.sh')
        else:
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    elif adType == 'female':
        if adAge == '(25,32)':
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
            #create slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/female_slides_2532.sh')
        else:
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    elif adType == 'generic':
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
        #create slides
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/generic_slide.sh')

    else:
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

def customerAnalysis(adType,adAge):
    print(adType)
    print(adAge)
    if adType == 'male':
        if adAge == '(25,32)':
            customer_ref.update({u'male_25to32': firestore.Increment(1)})
    elif adType == 'female':
        if adAge == '(25,32)':
            customer_ref.update({u'female_25to32': firestore.Increment(1)})


# Keep the app running
while True:

    image = cv2.imread(r"/home/viraj/Desktop/abc/images15.jpg") 

    imgGray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(imgGray, 1.2 , 2)

    ag_list = []
    gen_list = []

    customer_age = ''
    adType = ''

    for (x,y,w,h) in faces:
        cv2.rectangle(image, (x,y),(x+w,y+h),(0,0,255),2)
        imgFace = image[y:y+h,x:x+w].copy() # nurel network is only support for 3 chanel data
        blob = cv2.dnn.blobFromImage(imgFace, 1, (227, 227), MODEL_MEAN_VALUES, swapRB=False)
        # Binary Large Object ---> blob

        #predict age
        age_net.setInput(blob)
        age_pred = age_net.forward()
        age = age_list[age_pred[0].argmax()]

        ag_list.append(age)

        # predit gender
        gender_net.setInput(blob)
        gender_pred = gender_net.forward()
        gender = gender_list[gender_pred[0].argmax()]

        gen_list.append(gender)

        full_text = age + " " + gender
        # cv2.putText(image,full_text, (x,y) , cv2.FONT_HERSHEY_COMPLEX, 0.5, (255,0,0), 1)
        print(full_text)
    # cv2.imshow("Video" , image)

    if len(gen_list) > 1:
        rpi_ref.update({u'ad_type':u'generic'})
        i = 0
        for gen in gen_list:
            customerAnalysis(gen_list[i],ag_list[i])
            i += 1

    else:
        rpi_ref.update({u'ad_type':gen_list[0],u'ad_age':ag_list[0]})
        customerAnalysis(gen_list[0],ag_list[0])



    time.sleep(20)
