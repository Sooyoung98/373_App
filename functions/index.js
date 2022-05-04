const functions = require('firebase-functions');


const admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);
var msgData;


exports.offerTrigger = functions.firestore.document(
    'events/{eventId}'
    ).onCreate((snapshot,context)=>{

        msgData = snapshot.data();

        admin.firestore().collection('tokens').get().then((snapshots)=>{
            var tokens = [];
            if(snapshots.empty)
            {
            console.log('No Devices Found');
            }
            else{
            for(var pushTokens of snapshots.docs){
            tokens.push(pushTokens.data().token);
            }

            var payload ={
            'notification':{
                    'title': 'From ' + msgData.title,
                    'body': 'Offer is : ' + msgData.description,
                    'sound': 'default',
                },
            'data':{
                    'title': msgData.title,
                    'description': msgData.description,
                }
                };

            return admin.messaging().sendToDevice(tokens,    payload).then((response) => {
                console.log('pushed them all')
                }).catch((err) => {
                    console.log(err);
                });
        }
    });
});