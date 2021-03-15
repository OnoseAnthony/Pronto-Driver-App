import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fronto_rider/DataHandler/appData.dart';
import 'package:fronto_rider/Models/orders.dart';
import 'package:fronto_rider/Models/promotion.dart';
import 'package:fronto_rider/Models/users.dart';
import 'package:fronto_rider/Utils/enums.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  User firebaseUser;
  BuildContext context;

  DatabaseService({@required this.firebaseUser, this.context});

  //collection reference for user profile
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('Riders');

  //collection reference for user profile
  final CollectionReference customerProfileCollection =
      FirebaseFirestore.instance.collection('Customers');

  //collection reference for orders
  final CollectionReference userOrderCollection =
      FirebaseFirestore.instance.collection('Orders');

  //collection reference for notifications
  final CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('Notifications');

  //collection reference for support
  final CollectionReference userSupportCollection =
      FirebaseFirestore.instance.collection('Support');

  //collection reference for promotions
  final CollectionReference promotionCollection =
      FirebaseFirestore.instance.collection('Promotions');

  Future<bool> updateUserProfileData(
      String fName,
      String lName,
      String photoUrl,
      String accountNumber,
      String bankName,
      String bvn,
      String earnings,
      String deviceToken) async {
    CustomUser customUser = CustomUser(
      uid: firebaseUser.uid,
      fName: fName,
      lName: lName,
      photoUrl: photoUrl,
      earnings: earnings,
      isVerified: false,
    );

    try {
      await userProfileCollection.doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'fName': fName,
        'lName': lName,
        'photoUrl': photoUrl,
        'phoneNumber': firebaseUser.phoneNumber,
        'emailAddress': firebaseUser.email,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'bvn': bvn,
        'earnings': earnings,
        'isVerified': false,
        'deviceToken': deviceToken,
      });
      Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // Function to check if the uid exists in the firestore custom user collection
  Future<bool> checkUser() async {
    var document = await userProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // Function to check if the uid exists in the firestore customer collection
  Future<bool> checkCustomer() async {
    var document = await customerProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // method to return custom user data object from snapshot
  CustomUser _customUserDataFromSnapshot(DocumentSnapshot snapshot) {
    CustomUser customUser = CustomUser(
      uid: snapshot.get('uid'),
      fName: snapshot.get('fName'),
      lName: snapshot.get('lName'),
      photoUrl: snapshot.get('photoUrl'),
      earnings: snapshot.get('earnings'),
      accountNumber: snapshot.get('accountNumber'),
      bankName: snapshot.get('bankName'),
      bvn: snapshot.get('bvn'),
      isVerified: snapshot.get('isVerified'),
    );
    Provider.of<AppData>(context, listen: false).updateUserInfo(customUser);
    return customUser;
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
        itemDescription: doc.data()['itemDescription'],
        receiverImageUrl: doc.data()['receiverImageUrl'],
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

  // Function to get user orderOrders data from firestore
  Future<List<Order>> riderDeliveryList() async {
    QuerySnapshot snapshot = await userOrderCollection
        .where("driverID", isEqualTo: firebaseUser.uid)
        .orderBy('date', descending: true)
        .get();
    return (userOrderFromSnapshot(snapshot));
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
    String userID,
    //userID for the customer who initaited the order. NOTE: This is not the ID of the currently logged in rider!!!!!
    String orderID,
  ) async {
    if (label == 'NEW') {
      //since order has been accepted we save a notification which will trigger the firebase cloud function for push notification
      Map driverInfo = {
        'driverPhone': firebaseUser.phoneNumber,
        'driverName':
            '${Provider.of<AppData>(context, listen: false).userInfo.fName} ${Provider.of<AppData>(context, listen: false).userInfo.lName}',
      };

      String body =
          'Your package $orderID request has been accepted. Please place a call to the rider to confirm';
      try {
        await userOrderCollection.doc(docID).update({
          'orderStatus': OrderStatus.PENDING.toString(),
          'driverID': firebaseUser.uid,
          'driverPhone': firebaseUser.phoneNumber,
          'trackState': 2,
        });
        await addNotification(docID, userID, 'Pending', body, driverInfo);

        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    } else if (label == 'PENDING') {
      //since order has been delivered we update the notification which will trigger the firebase cloud function for push notification
      Map driverInfo = {
        'driverPhone': firebaseUser.phoneNumber,
        'driverName':
            '${Provider.of<AppData>(context, listen: false).userInfo.fName} ${Provider.of<AppData>(context, listen: false).userInfo.lName}',
      };

      String body = 'Your package $orderID has been delivered successfully.';

      try {
        await userOrderCollection.doc(docID).update({
          'orderStatus': OrderStatus.DELIVERED.toString(),
          'trackState': 3,
          'deliveryTimeStamp': DateTime.now().toString(),
          'deliveryDate': getCreationDate(),
        });
        await addNotification(docID, userID, 'Delivered', body, driverInfo);

        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
  }

  Future<void> addNotification(String docId, String userId, String title,
      String body, Map driverInfo) async {
    try {
      await notificationCollection.doc(docId).set({
        'userID': userId,
        'title': title,
        'body': body,
        'driverInfo': driverInfo,
        "date": getCreationDate(),
        "timeStamp": DateTime.now().toString(),
      });
    } catch (e) {}
  }

  Future<bool> submitQuery(String title, String description) async {
    try {
      await userSupportCollection.add({
        "userID": firebaseUser.uid,
        "userPhone": firebaseUser.phoneNumber,
        "title": title,
        "description": description,
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // method to return promotion from snapshot
  List<Promotion> promotionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Promotion(
        title: doc.data()['title'],
        body: doc.data()['body'],
        imageUrl: doc.data()['imageUrl'],
      );
    }).toList();
  }

  //Stream to get all recently submitted promotions from firestore
  Stream<List<Promotion>> get promotionStream {
    return promotionCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(promotionFromSnapshot);
  }
}
