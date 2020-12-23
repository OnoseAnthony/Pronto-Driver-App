import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fronto_rider/Models/orders.dart';
import 'package:fronto_rider/Screens/Dashboard/directions.dart';
import 'package:fronto_rider/Services/firebase/auth.dart';
import 'package:fronto_rider/Services/firebase/firestore.dart';
import 'package:fronto_rider/Services/firebase/pushNotificationService.dart';
import 'package:fronto_rider/SharedWidgets/buttons.dart';
import 'package:fronto_rider/SharedWidgets/customListTile.dart';
import 'package:fronto_rider/SharedWidgets/dialogs.dart';
import 'package:fronto_rider/SharedWidgets/drawer.dart';
import 'package:fronto_rider/SharedWidgets/tabs.dart';
import 'package:fronto_rider/SharedWidgets/text.dart';
import 'package:fronto_rider/SharedWidgets/tripTracker.dart';
import 'package:fronto_rider/Utils/enums.dart';
import 'package:fronto_rider/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController pageController;

  Color newContainerColor = kActiveContainerColor;
  Color pendingContainerColor = kInActiveContainerColor;
  Color deliveredContainerColor = kInActiveContainerColor;

  Color newTextColor = kActiveTextColor;
  Color pendingTextColor = kInActiveTextColor;
  Color deliveredTextColor = kInActiveTextColor;

  Color newBorderColor = kActiveBorderColor;
  Color pendingBorderColor = kInActiveBorderColor;
  Color deliveredBorderColor = kInActiveBorderColor;

  void updateDecoration(OrderStatus selectedOrderStatus) {
    if (selectedOrderStatus == OrderStatus.SUBMITTED) {
      if (newContainerColor == kInActiveContainerColor) {
        newContainerColor = kActiveContainerColor;
        newTextColor = kActiveTextColor;
        newBorderColor = kActiveBorderColor;

        pendingContainerColor = kInActiveContainerColor;
        pendingTextColor = kInActiveTextColor;
        pendingBorderColor = kInActiveBorderColor;

        deliveredContainerColor = kInActiveContainerColor;
        deliveredTextColor = kInActiveTextColor;
        deliveredBorderColor = kInActiveBorderColor;
      } else {
        newContainerColor = kActiveContainerColor;
        newTextColor = kActiveTextColor;
        newBorderColor = kActiveBorderColor;
      }
    }

    if (selectedOrderStatus == OrderStatus.PENDING) {
      if (pendingContainerColor == kInActiveContainerColor) {
        pendingContainerColor = kActiveContainerColor;
        pendingTextColor = kActiveTextColor;
        pendingBorderColor = kActiveBorderColor;

        newContainerColor = kInActiveContainerColor;
        newTextColor = kInActiveTextColor;
        newBorderColor = kInActiveBorderColor;

        deliveredContainerColor = kInActiveContainerColor;
        deliveredTextColor = kInActiveTextColor;
        deliveredBorderColor = kInActiveBorderColor;
      } else {
        pendingContainerColor = kActiveContainerColor;
        pendingTextColor = kActiveTextColor;
        pendingBorderColor = kActiveBorderColor;
      }
    }

    if (selectedOrderStatus == OrderStatus.DELIVERED) {
      if (deliveredContainerColor == kInActiveContainerColor) {
        deliveredContainerColor = kActiveContainerColor;
        deliveredTextColor = kActiveTextColor;
        deliveredBorderColor = kActiveBorderColor;

        pendingContainerColor = kInActiveContainerColor;
        pendingTextColor = kInActiveTextColor;
        pendingBorderColor = kInActiveBorderColor;

        newContainerColor = kInActiveContainerColor;
        newTextColor = kInActiveTextColor;
        newBorderColor = kInActiveBorderColor;
      } else {
        deliveredContainerColor = kActiveContainerColor;
        deliveredTextColor = kActiveTextColor;
        deliveredBorderColor = kActiveBorderColor;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getNotificationService(context);
    User user = AuthService().getCurrentUser();
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildDrawer(context),
      body: Stack(
        children: [
          Container(
            height: size,
            padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.1),
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StreamBuilder<List<Order>>(
                  stream: DatabaseService(firebaseUser: user, context: context)
                      .submittedOrderStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return buildStreamBuilderNullContainer('error');
                    else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      List<Order> orderList = snapshot.data;
                      if (snapshot.data != null && orderList.length >= 1) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: size * 0.15),
                          scrollDirection: Axis.vertical,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            print('item description is ${orderList[index]
                                .itemDescription}');
                            print('receiver name is ${orderList[index]
                                .receiverInfo}');
                            print('reciever image is ${orderList[index]
                                .receiverImageUrl}');
                            print('item image is ${orderList[index].itemUrl}');


                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: buildCard(
                                  orderList[index].docID,
                                  size,
                                  orderList[index].receiverImageUrl,
                                  orderList[index].receiverInfo,
                                  orderList[index].receiverPhone,
                                  orderList[index].itemUrl,
                                  orderList[index].itemDescription,
                                  orderList[index]
                                      .destinationAddress['placeName'],
                                  orderList[index].pickUpAddress['stateName'],
                                  orderList[index]
                                      .destinationAddress['stateName'],
                                  'NEW',
                                  orderList[index].pickUpAddress,
                                  orderList[index].destinationAddress),
                            );
                          },
                        );
                      } else {
                        return buildStreamBuilderNullContainer('NEW');
                      }
                    } else {
                      return buildStreamBuilderLoader();
                    }
                  },
                ),
                StreamBuilder<List<Order>>(
                  stream: DatabaseService(firebaseUser: user, context: context)
                      .pendingOrderStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return buildStreamBuilderNullContainer(
                          'Error occurred!!!');
                    else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      List<Order> orderList = snapshot.data;
                      if (snapshot.data != null && orderList.length >= 1) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: size * 0.15),
                          scrollDirection: Axis.vertical,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: buildCard(
                                  orderList[index].docID,
                                  size,
                                  orderList[index].receiverImageUrl,
                                  orderList[index].receiverInfo,
                                  orderList[index].receiverPhone,
                                  orderList[index].itemUrl,
                                  orderList[index].itemDescription,
                                  orderList[index]
                                      .destinationAddress['placeName'],
                                  orderList[index].pickUpAddress['stateName'],
                                  orderList[index]
                                      .destinationAddress['stateName'],
                                  'PENDING',
                                  orderList[index].pickUpAddress,
                                  orderList[index].destinationAddress),
                            );
                          },
                        );
                      } else {
                        return buildStreamBuilderNullContainer('PENDING');
                      }
                    } else {
                      return buildStreamBuilderLoader();
                    }
                  },
                ),
                StreamBuilder<List<Order>>(
                  stream: DatabaseService(firebaseUser: user, context: context)
                      .completedOrderStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return buildStreamBuilderNullContainer(
                          'Error occurred!!');
                    else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      List<Order> orderList = snapshot.data;
                      if (snapshot.data != null && orderList.length >= 1) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: size * 0.15),
                          scrollDirection: Axis.vertical,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: buildCard(
                                  orderList[index].docID,
                                  size,
                                  orderList[index].receiverImageUrl,
                                  orderList[index].receiverInfo,
                                  orderList[index].receiverPhone,
                                  orderList[index].itemUrl,
                                  orderList[index].itemDescription,
                                  orderList[index]
                                      .destinationAddress['placeName'],
                                  orderList[index].pickUpAddress['stateName'],
                                  orderList[index]
                                      .destinationAddress['stateName'],
                                  'DELIVERED',
                                  orderList[index].pickUpAddress,
                                  orderList[index].destinationAddress),
                            );
                          },
                        );
                      } else {
                        return buildStreamBuilderNullContainer('DELIVERED');
                      }
                    } else {
                      return buildStreamBuilderLoader();
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Material(
              elevation: 4,
              shadowColor: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: size * 0.12,
                    bottom: size * 0.015),
                child: buildTabBarContainer(context),
              ),
            ),
          ),
          Positioned(
            top: size * 0.07,
            left: 10,
            child: InkWell(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: getIcon(Icons.menu, 25, Colors.black),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> getNotificationService(context) async {
    await NotificationService(context: context).getTokenString();
  }

  buildStreamBuilderLoader() {
    return Container(
      child: Center(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          child: Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SpinKitWanderingCubes(
                  color: Colors.white,
                  size: 30.0,
                ),
                SizedBox(
                  width: 30,
                ),
                buildTitlenSubtitleText('please wait a moment...', Colors.white,
                    14, FontWeight.bold, TextAlign.center, null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildStreamBuilderNullContainer(String label) {
    return Container(
        child: Center(
            child: Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            buildTitlenSubtitleText(
                label == 'NEW'
                    ? 'No new deliveries yet...'
                    : label == 'PENDING'
                        ? 'No accepted packages yet...'
                        : label == 'DELIVERED'
                            ? 'No completed deliveries yet...'
                            : 'ERROR!!!',
                Colors.white,
                14,
                FontWeight.bold,
                TextAlign.center,
                null),
          ],
        ),
      ),
    )));
  }

  buildTabBarContainer(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                updateDecoration(OrderStatus.SUBMITTED);
                pageController.animateToPage(0,
                    duration: Duration(milliseconds: 254),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: createTabBarElement(
                'NEW', newContainerColor, newBorderColor, newTextColor, 70),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                updateDecoration(OrderStatus.PENDING);
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 254),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: createTabBarElement('PENDING', pendingContainerColor,
                pendingBorderColor, pendingTextColor, 80),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                updateDecoration(OrderStatus.DELIVERED);
                pageController.animateToPage(2,
                    duration: Duration(milliseconds: 254),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: createTabBarElement('DELIVERED', deliveredContainerColor,
                deliveredBorderColor, deliveredTextColor, 90),
          ),
        ],
      ),
    );
  }

  buildCard(
      String docID,
      double size,
      String receiverImage,
      String receiverName,
      String receiverPhone,
      String itemImage,
      String itemDescription,
      String itemDestinationLocation,
      String itemPickUpStateName,
      String itemDestinationStateName,
      String label,
      var pickUpAddress,
      var destinationAddress) {
    return Card(
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: size * 0.02),
        child: Column(
          children: [


            buildCustomListTile(
                buildContainerImage(receiverImage),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      buildTitlenSubtitleText(receiverName, Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      SizedBox(
                        height: 8,
                      ),
                      buildTitlenSubtitleText(
                          receiverPhone,
                          Colors.grey[500],
                          12,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.visible),
                    ],
                  ),
                ),
                null,
                20,
                false),


            SizedBox(
              height: 20,
            ),


            buildCustomListTile(
                buildContainerImage(itemImage),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      buildTitlenSubtitleText(itemDescription, Colors.black, 16,
                          FontWeight.normal, TextAlign.start, null),
                      SizedBox(
                        height: 8,
                      ),
                      buildTitlenSubtitleText(
                          itemDestinationLocation,
                          Colors.grey[500],
                          12,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.visible),
                    ],
                  ),
                ),
                null,
                20,
                false),


            SizedBox(
              height: 30,
            ),


            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitlenSubtitleText(
                        itemPickUpStateName,
                        Colors.grey[500],
                        16,
                        FontWeight.w700,
                        TextAlign.start,
                        null),
                    buildTitlenSubtitleText(
                        itemDestinationStateName,
                        Colors.grey[500],
                        16,
                        FontWeight.w700,
                        TextAlign.start,
                        null),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                buildDestinationTracker(
                    context, label == 'DELIVERED' ? true : false),
              ],
            ),
            label == 'DELIVERED'
                ? SizedBox(
                    height: 0,
                  )
                : SizedBox(
                    height: 20,
                  ),
            label == 'NEW' || label == 'DELIVERED'
                ? Container()
                : InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (context) => Container(
                                height: size * 0.80,
                                child: DirectionScreen(
                                  pickUpLat: pickUpAddress['latitude'],
                                  pickUpLong: pickUpAddress['longitude'],
                                  pickUpPlaceName: pickUpAddress['placeName'],
                                  destinationLat:
                                      destinationAddress['latitude'],
                                  destinationLong:
                                      destinationAddress['longitude'],
                                  destinationPlaceName:
                                      destinationAddress['placeName'],
                                ),
                              ));
                    },
                    child: buildSubmitButton(
                      'VIEW',
                      5.0,
                      true,
                    ),
                  ),
            label == 'NEW' || label == 'DELIVERED'
                ? Container()
                : SizedBox(
                    height: 15,
                  ),
            label == 'NEW' || label == 'PENDING'
                ? InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => NavigationLoader(context),
                      );

                      if (label == 'NEW') {
                        bool isUpdated = await DatabaseService(
                                firebaseUser: AuthService().getCurrentUser(),
                                context: context)
                            .updateOrderInfo('NEW', docID);

                        if (isUpdated) {
                          Navigator.pop(context);

                          showToast(
                              context,
                              'Order request accepted successfully',
                              Colors.blue);
                        } else {
                          Navigator.pop(context);

                          showToast(context, 'Error occurred!!', Colors.red);
                        }
                      } else if (label == 'PENDING') {
                        bool isUpdated = await DatabaseService(
                                firebaseUser: AuthService().getCurrentUser(),
                                context: context)
                            .updateOrderInfo('PENDING', docID);

                        if (isUpdated) {
                          Navigator.pop(context);

                          showToast(
                              context,
                              'Delivery confirmation processed successfully',
                              Colors.blue);
                        } else {
                          Navigator.pop(context);

                          showToast(context, 'Error occurred!!', Colors.red);
                        }
                      }
                    },
                    child: buildSubmitButton(
                        label == 'NEW' ? 'ACCEPT' : 'CONFIRM', 5.0, false),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
