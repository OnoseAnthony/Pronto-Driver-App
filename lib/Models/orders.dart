import 'dart:io';
import 'dart:math';

class Order {
  String docID;
  String userID;
  String userPhone;
  String orderID;
  String paymentReferenceID;
  String date;
  String timeStamp;
  String receiverInfo;
  String receiverPhone;
  String itemDescription;
  String receiverImageUrl;
  String itemUrl;
  String paymentStatus;
  String chargeAmount;
  String orderStatus;
  int trackState;
  Map pickUpAddress;
  Map destinationAddress;
  String driverID;
  String driverPhone;

  Order(
      {this.docID,
      this.userID,
      this.userPhone,
      this.orderID,
      this.paymentReferenceID,
      this.date,
      this.timeStamp,
      this.receiverInfo,
      this.receiverPhone,
      this.itemDescription,
      this.receiverImageUrl,
      this.itemUrl,
      this.paymentStatus,
      this.chargeAmount,
      this.orderStatus,
      this.trackState,
      this.pickUpAddress,
      this.destinationAddress,
      this.driverID,
      this.driverPhone});
}

class orderRequest {
  File receiverImage;
  File itemImage;
  String receiverPhone;
  String receiverInfo;
  String itemDescription;

  orderRequest({
    this.receiverImage,
    this.itemImage,
    this.receiverPhone,
    this.itemDescription,
    this.receiverInfo,
  });
}

String getOrderID() {
  var random = Random.secure();
  var value = random.nextInt(9999);
  String stringValue = value.toString();
  return 'Order${stringValue}PR';
}

String getCreationDate() {
  String day = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  String creatiomDate = '$day $month. $year';
  return creatiomDate;
}
