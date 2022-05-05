const functions = require('firebase-functions');


const admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);
var msgData;


exports.createEventTrigger = functions.firestore.document(
    'events/{eventId}'
    ).onCreate((snapshot,context)=>{

        msgData = snapshot.data();

        if (msgData.repeatType == "Urgent") {
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
                        'title': 'New Event: ' + msgData.title,
                        'body': 'Join the event on ' + msgData.date.toDate().toDateString(),
                        'sound': 'default',
                    }
                    };
    
                return admin.messaging().sendToDevice(tokens,    payload).then((response) => {
                    console.log('pushed them all')
                    }).catch((err) => {
                        console.log(err);
                    });
            }
        });
        }

});

// exports.editEventTrigger = functions.firestore.document(
//     'events/{eventId}'
//     ).onUpdate((change,context)=>{

//         msgData = change.after.data();

//         if (msgData.repeatType == "Urgent") {
//             admin.firestore().collection('tokens').get().then((snapshots)=>{
//                 var tokens = [];
//                 if(snapshots.empty)
//                 {
//                 console.log('No Devices Found');
//                 }
//                 else{
//                 for(var pushTokens of snapshots.docs){
//                 tokens.push(pushTokens.data().token);
//                 }
    
//                 var payload ={
//                 'notification':{
//                         'title': 'Updated Event: ' + msgData.title,
//                         'body': 'Join the event on ' + msgData.date.toDate().toDateString(),
//                         'sound': 'default',
//                     }
//                     };
    
//                 return admin.messaging().sendToDevice(tokens,    payload).then((response) => {
//                     console.log('pushed them all')
//                     }).catch((err) => {
//                         console.log(err);
//                     });
//             }
//         });
//         }

        

        
// });