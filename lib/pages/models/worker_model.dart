import 'package:firebase_database/firebase_database.dart';

class Worker {
  String? email;
  String? uid;
  String? phoneNumber;
  String? fullName;
  String? dt;
  String? type;
  String? address;
  String? imageUrl;
  int? rating;

  Worker(
      {this.email,
      this.uid,
      this.phoneNumber,
      this.fullName,
      this.dt,
      this.type,
      this.address,
      this.imageUrl, this.rating});

  Worker.fromSnapshot(DataSnapshot dataSnapshot) {
    uid = (dataSnapshot.child("uid").value.toString());
    email = (dataSnapshot.child("email").value.toString());
    fullName = (dataSnapshot.child("name").value.toString());
    phoneNumber = (dataSnapshot.child("phoneNumber").value.toString());
    dt = (dataSnapshot.child("dt").value.toString());
    type = (dataSnapshot.child("type").value.toString());
    address = (dataSnapshot.child("address").value.toString());
    imageUrl = (dataSnapshot.child("imageUrl").value.toString());
    rating = (dataSnapshot.child("rating").value.toString()) as int?;
  }
}
