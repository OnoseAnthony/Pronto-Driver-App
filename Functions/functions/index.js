const functions = require('firebase-functions');
const admin = require('firebase-admin');


admin.initializeApp(functions.config().functions);


var snapshotData;


exports.notificationTrigger = functions.firestore.document('Orders/{ordersId}').onCreate(async (snapshot, context ) => {
    if (snapshot.empty){
        console.log('No Devices');
        return;
    }

    var tokens = [];

    const snapshotData = snapshot.data();

    const destinationState = snapshotData.destinationAddress.stateName;
    const destinationPlace = snapshotData.destinationAddress.placeName;
    const pickupState = snapshotData.pickUpAddress.stateName;
    const itemDescription = snapshotData.itemDescription;
    const userPhoneID = snapshotData.userPhone;



    const deviceTokens = await admin.firestore().collection('DeviceTokens').get();

    for (var token of deviceTokens.docs){
        tokens.push(token.data().deviceToken)
    }




    var payload =  {
        notification: {title: 'New Delivery Request', body: `A request to deliver ${itemDescription} to ${destinationPlace} ${destinationState} was just placed by ${userPhoneID}. Click to accept`, sound: 'enabled', },
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








