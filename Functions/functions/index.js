const functions = require('firebase-functions');
const admin = require('firebase-admin');


admin.initializeApp(functions.config().functions);


var snapshotData;
var snapshotData1;
var snapshotData2;


exports.sendNotificationToRider = functions.firestore.document('Orders/{ordersId}').onCreate(async (snapshot, context ) => {
    if (snapshot.empty){
        console.log('No Devices');
        return;
    }

    var tokens = [];

    const snapshotData = snapshot.data();

    const itemImageUrl = snapshotData.itemUrl;
    const destinationState = snapshotData.destinationAddress.stateName;
    const destinationPlace = snapshotData.destinationAddress.placeName;
    const pickupState = snapshotData.pickUpAddress.stateName;
    const itemDescription = snapshotData.itemDescription;
    const userPhoneID = snapshotData.userPhone;



    const deviceTokens = await admin.firestore().collection('Riders').get();

    for (var token of deviceTokens.docs){
        tokens.push(token.data().deviceToken)
    }




    var payload =  {
        notification: {title: 'New Delivery Request', body: `A request to deliver ${itemDescription} to ${destinationPlace} ${destinationState} was just placed by ${userPhoneID}. Click to accept`, sound: 'enabled', image: `${itemImageUrl}`,  click_action: 'FLUTTER_NOTIFICATION_CLICK', },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: ''}
    };

    try{
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification Sent Successfully');
    }catch(e){
        console.log(e);
        console.log('Notification Not Sent');
    }
});


exports.sendNotificationToUser = functions.firestore.document('Orders/{ordersId}').onUpdate(async(change, context) => {

    if (change.empty){
        console.log('No Devices');
        return;
    }


    const snapshotData1 = change.after.data();
    const previousSnapshotData = change.before.data();

    const previousUserOrderStatus = previousSnapshotData.orderStatus;

    const userId = snapshotData1.userID;
    const userOrderStatus = snapshotData1.orderStatus;
    const itemUrl = snapshotData1.itemUrl;
    const destinationState = snapshotData1.destinationAddress.stateName;
    const destinationPlace = snapshotData1.destinationAddress.placeName;
    const pickupState = snapshotData1.pickUpAddress.stateName;
    const itemDescription = snapshotData1.itemDescription;
    const driverPhoneID = snapshotData1.driverPhone;


    const customer = await admin.firestore().collection('Customers').doc(userId).get();

    const userDeviceTokenSnapshot = customer.get('deviceToken');

    var userDeviceToken = [userDeviceTokenSnapshot,];



    if (userOrderStatus === 'OrderStatus.PENDING' && previousUserOrderStatus !== userOrderStatus){

        var payload =  {
            notification: {title: 'Delivery Request Accepted', body: `Your request to deliver ${itemDescription} to ${destinationPlace} ${destinationState} was just accepted by ${driverPhoneID}. Click to call rider`, sound: 'enabled', image: `${itemUrl}`, click_action: 'FLUTTER_NOTIFICATION_CLICK',},
            data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'orderNotification', 'category': 'orderNotification', 'title': '', 'body': '',  'imageUrl': '',}
        };

        try{
            const response = await admin.messaging().sendToDevice(userDeviceToken, payload);
            console.log('Notification Sent Successfully');
        }catch(e){
            console.log(e);
            console.log('Notification Not Sent');
        }
    }else if (userOrderStatus === 'OrderStatus.DELIVERED' && previousUserOrderStatus !== userOrderStatus){

        var notificationPayload =  {
            notification: {title: 'Item Delivered', body: `Your request to deliver ${itemDescription} to ${destinationPlace} ${destinationState} has been completed successfully.`, sound: 'enabled', image: `${itemUrl}`,  click_action: 'FLUTTER_NOTIFICATION_CLICK', },
            data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'orderNotification', 'category': 'orderNotification', 'title': '', 'body': '',  'imageUrl': '',}
        };

        try{
            const response = await admin.messaging().sendToDevice(userDeviceToken, notificationPayload);
            console.log('Notification Sent Successfully');
        }catch(e){
            console.log(e);
            console.log('Notification Not Sent');
        }
    }
});


exports.sendPromotionToCustomers = functions.firestore.document('Promotions/{promotionsId}').onCreate(async (snapshot, context ) => {
    if (snapshot.empty){
        console.log('No Devices');
        return;
    }

    var customerDeviceTokens = [];

    const snapshotData2 = snapshot.data();

    const title = snapshotData2.title;
    const body = snapshotData2.body;
    const imageUrl = snapshotData2.imageUrl;



    const customerDeviceTokenSnapshot = await admin.firestore().collection('Customers').get();

    for (var token of customerDeviceTokenSnapshot.docs){
        customerDeviceTokens.push(token.data().deviceToken)
    }


    var promotionPayload =  {
        notification: {title: `${title}`, body: `${body} Click to view`, sound: 'enabled', image: `${imageUrl}`, click_action: 'FLUTTER_NOTIFICATION_CLICK',},
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'promotion', 'category': 'promotion', 'title': title, 'body': body, 'imageUrl': imageUrl,}
    };



    try{
        const response = await admin.messaging().sendToDevice(customerDeviceTokens, promotionPayload);
        console.log('Notification Sent Successfully');
    }catch(e){
        console.log(e);
        console.log('Notification Not Sent');
    }
});







