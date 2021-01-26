#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# import os

# os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/male_ads.sh ' + "abc")

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# import getmac
import datetime

# Use a service account
cred = credentials.Certificate('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/flashapp-7027e-firebase-adminsdk-fz2rt-714ca34e83.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

# macAddr = getmac.get_mac_address()

macAddr = u'b8:27:eb:88:85:92'

rpi_ref = db.collection(u'signage units').document(macAddr)
rpi_mac = rpi_ref.get()

if rpi_mac.exists: 

    ad_ref = rpi_ref.collection(u'advertisements')
    ads = ad_ref.stream()

    for ad in ads:
        print(f'{ad.id}')   





else:
    rpi_ref.set({
        u'manufactured date': datetime.datetime.now(),
    })
  
# users_ref = db.collection(u'users')
# docs = users_ref.stream()

# for doc in docs:
#     print(f'{doc.id} => {doc.to_dict()}')