#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# import os

# os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/male_ads.sh ' + "abc")

import threading
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

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

#function to get ads from firestore
def getAds(male_ads_dict, female_ads_dict, generic_ads_dict):
    # macAddr = getmac.get_mac_address()
    macAddr = u'b8:27:eb:88:85:92'

    rpi_ref = db.collection(u'signage units').document(macAddr)
    rpi_mac = rpi_ref.get()

    if rpi_mac.exists: 
        print("device exists")
    else:
        rpi_ref.set({
            u'manufactured date': datetime.datetime.now(),
        })

    ads_ref = rpi_ref.collection(u'advertisements')
    
    # Create an Event for notifying main thread.
    callback_done = threading.Event()

    # Create a callback on_snapshot function to capture changes
    def on_snapshot(col_snapshot, changes, read_time):
        print(u'Callback received query snapshot.')
        print(u'Current cities in California:')
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

getAds(male_ads_dict, female_ads_dict, generic_ads_dict)
# Keep the app running
while True:
    time.sleep(1)
    print('processing...')