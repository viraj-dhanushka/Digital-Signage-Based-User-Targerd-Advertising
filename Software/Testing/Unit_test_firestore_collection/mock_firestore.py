from unittest import TestCase
import unittest
from mockfirestore import MockFirestore, DocumentReference, DocumentSnapshot, AlreadyExists
import google.cloud
from google.cloud import firestore

class TestCollectionReference(TestCase):
    
    #query the existance of issued power supply collection when user add device
    def test_issued_MacAddress_exists_or_not_exists(self):
        fs = MockFirestore()
        fs._data = {'issued power supply units': {
            '84:CC:A8:84:B8:10':{'buyerID': 1234},
            '84:CC:A8:84:B8:20': {'buyerID': 1212},
            '84:CC:A8:84:B8:30': {'buyerID': 2911},
            '84:CC:A8:84:B8:40': {'buyerID': 1010},
            
        }}
        doc1 = fs.collection('issued power supply units').document('84:CC:A8:84:B8:10').get()
        doc2 = fs.collection('issued power supply units').document('84:CC:A8:84:B8:20').get()
        doc3 = fs.collection('issued power supply units').document('84:CC:A8:84:B8:50').get()
        #assert to check documents snapshot exists
        self.assertTrue(doc1.exists)
        self.assertTrue(doc2.exists)
        #assert to check documents snapshot not_exist 
        self.assertFalse(doc3.exists)

    #test issued document snapshot exists
    def test_MacAddress_exists_or_not_exists(self):
        fs = MockFirestore()
        fs._data = {'user power supply units': {
            '84:CC:A8:84:B8:00':{'status': 'false'},
            '84:CC:A8:84:B8:20': {'status': 'true'},
            '84:CC:A8:84:B8:40': {'status': 'false'},
            
        }}
        doc1 = fs.collection('user power supply units').document('84:CC:A8:84:B8:00').get()
        doc2 = fs.collection('user power supply units').document('84:CC:A8:84:B8:20').get()
        doc3 = fs.collection('user power supply units').document('84:CC:A8:84:B8:11').get()
        #assert to check documents exist and able to retrieve
        self.assertTrue(doc1.exists)
        self.assertTrue(doc2.exists)
        #assert to check documents not_exist 
        self.assertFalse(doc3.exists)

    #test screen state updates are taken by each mac Address document
    def test_document_set_screenOn_status_updates(self):
        fs = MockFirestore()
        fs._data = {'user power supply units': {
            '84:CC:A8:84:B8:00':{'ScreenState': 'ON'},
            '84:CC:A8:84:B8:20': {'ScreenState': 'OFF'},
            '84:CC:A8:84:B8:40': {'ScreenState': 'ON'},   
        }}
        fs.collection('user power supply units').document('84:CC:A8:84:B8:00').set({'ScreenState': 'OFF'}, merge=False)
        doc = fs.collection('user power supply units').document('84:CC:A8:84:B8:00').get().to_dict()
        self.assertEqual({'ScreenState': 'OFF'}, doc)

        fs.collection('user power supply units').document('84:CC:A8:84:B8:20').set({'ScreenState': 'ON'}, merge=False)
        doc1 = fs.collection('user power supply units').document('84:CC:A8:84:B8:20').get().to_dict()
        self.assertNotEqual({'ScreenState': 'OFF'}, doc1)

    #deleting added devices to the user power supply units collection
    def test_document_delete_MacAddress_NotExist_After_Delete(self):
        fs = MockFirestore()
        fs._data = {'user power supply units': {
            '84:CC:A8:84:B8:00':{'ScreenState': 'ON'},
            '84:CC:A8:84:B8:20': {'ScreenState': 'OFF'},
            '84:CC:A8:84:B8:40': {'ScreenState': 'ON'},   
        }}
        fs.collection('user power supply units').document('84:CC:A8:84:B8:20').delete()
        doc = fs.collection('user power supply units').document('84:CC:A8:84:B8:20').get()
        self.assertEqual(False, doc.exists)
    
    #test for analytics increment male,female count when the user detect system captures
    def test_analytics_male_female_count_increment(self):
        fs = MockFirestore()
        fs._data = {'advertisements': {
            'analytics': {
                'male': {'count': 20},
                'female': {'count': 10},
            }
        }}
        fs.collection('advertisements').document('analytics').update({
            'male': {'count': firestore.Increment(1)},
            'female': {'count': firestore.Increment(1)},
        })

        doc = fs.collection('advertisements').document('analytics').get().to_dict()
        self.assertEqual(doc, {
            'male': {'count': 21},
            'female': {'count': 11}
        })

    
if __name__ == '__main__':
    unittest.main(verbosity=2)