import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Models/orders.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Utils/enums.dart';
import 'package:provider/provider.dart';

// import 'package:fronto_rider/Services/firebase/auth.dart';
// import 'package:fronto_rider/Services/firebase/storage.dart';
// import 'package:fronto_rider/Utils/enums.dart';

class DatabaseService {
  User firebaseUser;
  BuildContext context;

  DatabaseService({@required this.firebaseUser, this.context});

  //collection reference for user profile
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('CustomUser');

  //collection reference for orders
  final CollectionReference userOrderCollection =
      FirebaseFirestore.instance.collection('Orders');

  Future updateUserProfileData(
      bool isDriver, String fName, String lName, String photoUrl) async {
    CustomUser customUser = CustomUser(
      uid: firebaseUser.uid,
      isDriver: isDriver,
      fName: fName,
      lName: lName,
      photoUrl: photoUrl,
    );
    Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
    return await userProfileCollection.doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'isDriver': isDriver,
      'fName': fName,
      'lName': lName,
      'photoUrl': photoUrl
    });
  }

  // Function to check if the uid exists in the firestore custom user collection
  Future<bool> checkUser() async {
    var document = await userProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // Function to check if the isDriver Field is true of false in the firestore custom user collection
  Future<bool> checkUserIsDriver() async {
    DocumentSnapshot document =
        await userProfileCollection.doc(firebaseUser.uid).get();
    bool isDriver = document.get('isDriver');
    if (isDriver == true)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // method to return custom user data object from snapshot
  CustomUser _customUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser.fromMap(snapshot.data());
  }

  // Function to get custom user data from firestore
  Future<CustomUser> getCustomUserData() async {
    DocumentSnapshot snapshot =
        await userProfileCollection.doc(firebaseUser.uid).get();
    return _customUserDataFromSnapshot(snapshot);
  }

  // method to return user order object from snapshot
  List<Order> userOrderFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Order(
        docID: doc.id,
        userID: doc.data()['userID'],
        userPhone: doc.data()['userPhone'],
        orderID: doc.data()['orderID'],
        paymentReferenceID: doc.data()['paymentReferenceID'],
        date: doc.data()['date'],
        timeStamp: doc.data()['date'] ?? 'EMPTY',
        receiverInfo: doc.data()['receiverInfo'],
        receiverPhone: doc.data()['receiverPhone'],
        itemDescription: doc.data()['receiverInfo'],
        receiverImageUrl: doc.data()['itemDescription'],
        itemUrl: doc.data()['itemUrl'],
        paymentStatus: doc.data()['paymentStatus'] ?? 'EMPTY',
        chargeAmount: doc.data()['chargeAmount'].toString(),
        orderStatus: doc.data()['orderStatus'],
        trackState: doc.data()['trackState'],
        pickUpAddress: doc.data()['pickUpAddress'],
        destinationAddress: doc.data()['destinationAddress'],
        driverID: doc.data()['driverID'] ?? 'EMPTY',
        driverPhone: doc.data()['driverPhone'] ?? 'EMPTY',
      );
    }).toList();
  }

  //Stream to get all recently submitted order data from firestore and display them in the admin app
  Stream<List<Order>> get submittedOrderStream {
    return userOrderCollection
        .where("orderStatus", isEqualTo: OrderStatus.SUBMITTED.toString())
        .orderBy('date', descending: true)
        .snapshots()
        .map(userOrderFromSnapshot);
  }

  //Stream to get all recently pending order data for a particular driver from firestore and display them in the admin app
  Stream<List<Order>> get pendingOrderStream {
    return userOrderCollection
        .where('driverID', isEqualTo: firebaseUser.uid)
        .where("orderStatus", isEqualTo: OrderStatus.PENDING.toString())
        .snapshots()
        .map(userOrderFromSnapshot);
  }

  //Stream to get all recently completed order data for a particular driver from firestore and display them in the admin app
  Stream<List<Order>> get completedOrderStream {
    return userOrderCollection
        .where('driverID', isEqualTo: firebaseUser.uid)
        .where("orderStatus", isEqualTo: OrderStatus.DELIVERED.toString())
        .snapshots()
        .map(userOrderFromSnapshot);
  }

  // Function to update order status for a particular order in firestore
  Future<bool> updateOrderInfo(
    String label,
    String docID,
  ) async {
    if (label == 'NEW')
      try {
        await userOrderCollection.doc(docID).update({
          'orderStatus': OrderStatus.PENDING.toString(),
          'driverID': firebaseUser.uid,
          'driverPhone': firebaseUser.phoneNumber,
          'trackState': 2,
        });

        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    else
      try {
        await userOrderCollection.doc(docID).update({
          'orderStatus': OrderStatus.DELIVERED.toString(),
          'trackState': 3,
          'deliveryTimeStamp': DateTime.now().toString(),
          'deliveryDate': getCreationDate(),
        });
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }
}
