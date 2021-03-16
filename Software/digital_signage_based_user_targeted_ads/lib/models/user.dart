import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String company;
  String companyBranch;
  String jobTitle;
  String whatsappNum;
  String contactNum;
  String photoUrl;

  String age;
  String homeNumber;
  String street1;
  String street2;
  String city;
  String type;

  User(
      {this.id,
      this.name,
      this.company,
      this.companyBranch,
      this.jobTitle,
      this.whatsappNum,
      this.contactNum,
      this.photoUrl,
      this.age,
      this.homeNumber,
      this.street1,
      this.street2,
      this.city,
      this.type
      });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      name: doc['name'],
      company: doc['company'],
      companyBranch: doc['companyBranch'],
      jobTitle: doc['jobTitle'],
      whatsappNum: doc['whatsappNum'],
      contactNum: doc['contactNum'],
      photoUrl: doc['photoUrl'],
      age: doc['age'],
      homeNumber: doc['homeNumber'],
      street1: doc['street1'],
      street2: doc['street2'],
      city: doc['city'],
      type: doc['type']
    );
  }
}
