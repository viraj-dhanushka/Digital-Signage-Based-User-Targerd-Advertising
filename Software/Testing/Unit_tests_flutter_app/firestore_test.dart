import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

void main() {
  group("testing for firestore retrieve", () {
    //arrange
    MockFirestoreInstance instance;
    setUp(() {
      instance = MockFirestoreInstance();

      final collectionRef = instance.collection('MacAddresses');
      final data1 = {'Mac1': '1313'};
      final data2 = {'Mac1': '1212'};
      final data3 = {'Mac1': '1414', 'Mac2': '1010', 'Mac3': '1515'};
      collectionRef.add(data1);
      collectionRef.add(data2);
      collectionRef.add(data3);
    });

    test('If user input Mac Valid', () async {
      // assert
      bool macExist = false;
      final addresses =
          await instance.collection('MacAddresses').getDocuments();
      String inputMac1 = "1010";

      print(instance.dump()); //firestore structure of collection
      //loop through topics to find if mac exists
      //assert
      for (var mac in addresses.documents) {
        for (var val in mac.data.values) {
          if (val == inputMac1) {
            macExist = true;
            break;
          }
        }
      }
      expect(macExist, true);
    });
    test('if user input Mac InValid', () async {
      // act
      final addresses =
          await instance.collection('MacAddresses').getDocuments();
      String inputMac2 = "12";
      bool macExist = false;

      print(instance.dump()); //firestore structure of collection
      //loop through topics to find if mac exists
      //assert
      for (var mac in addresses.documents) {
        for (var val in mac.data.values) {
          if (val == inputMac2) {
            macExist = true;
            break;
          }
        }
      }
      expect(macExist, false);
    });
  });
}
