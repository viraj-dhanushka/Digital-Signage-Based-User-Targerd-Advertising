#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os

# os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/ads.sh ' + "abcddd" + ' ' + 'https://i.pinimg.com/originals/8a/c0/4f/8ac04fb2af0efb66e07641f4dd335c4f.jpg' )

import threading
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
# import getmac
import datetime
import time

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
ads_ref = rpi_ref.collection(u'advertisements')

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
            showAd(adStates_dict["ad type"],adStates_dict["ad age"])
        else:
            print("do not do targetting")

    callback_done.set()

# Watch the document
doc_watch = rpi_ref.on_snapshot(on_snapshot)    

#function to show ad from firestore
def showAd(adType,adAge):
    # adType_ref = ads_ref.document(adType)
    # ad_doc = adType_ref.get()
    # if ad_doc.exists:
    #     ad = ad_doc.to_dict()
    #     if adAge >= 15 and adAge <= 20:
    #         print(ad['15:20'])
    #     if adAge >= 25 and adAge <= 32:
    #         print(ad['25:32'])
    #     if adAge >= 38 and adAge <= 43:
    #         print(ad['38:43'])
    # else:
    #     print(u'No such document!')

    if adType == 'male':
        if adAge >= 25 and adAge <= 32:
            # r = requests.get('https://docs.google.com/presentation/d/1xFO-aSyLuq5-O3ElnLB8lB1ABHE98RFGutrSGo8IjRg/edit?usp=sharing')
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/male_slides.sh')

    if adType == 'female':
        if adAge >= 25 and adAge <= 32:
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/female_2532.sh')

    if adType == 'generic':

        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/generic_ads.sh')

    else:
        print(u'No such ad!')

#function to get ads from firestore
def getAds(male_ads_dict, female_ads_dict, generic_ads_dict):

    # Create an Event for notifying main thread.
    callback_done = threading.Event()

    # Create a callback on_snapshot function to capture changes
    def on_snapshot(col_snapshot, changes, read_time):
        for doc in col_snapshot:
            if doc.id == 'male':
                male_ads_dict = doc.to_dict()
                print(male_ads_dict)
            if doc.id == 'female':
                female_ads_dict = doc.to_dict()
            if doc.id == 'generic':
                generic_ads_dict = doc.to_dict()

        callback_done.set()

    col_query = ads_ref

    # Watch the collection query
    query_watch = col_query.on_snapshot(on_snapshot)

  
# users_ref = db.collection(u'users')
# docs = users_ref.stream()

# for doc in docs:
#     print(f'{doc.id} => {doc.to_dict()}')

# getAds(male_ads_dict, female_ads_dict, generic_ads_dict)



# Keep the app running
while True:

    time.sleep(1)
