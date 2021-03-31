//  utilizar modulo functions
const functions = require("firebase-functions");
// admin sdk
const admin = require("firebase-admin");

admin.initializeApp();

//cloud firestore
//const db= admin.firestore();

//detecta un cambio en la bbdd (trigger on write) y hace algo
exports.updateRestaurantRating = functions.firestore
    .document('users/90LoXsHV2phBLl0t6BkO')
    .onWrite(async (change, _) => await updateRating(change))

async function updateRating(change) {

    const restaurantRatingsRef = change.after.ref.parent
    let numRatings = 0
    let total = 0
    const docRefs = await restaurantRatingsRef.listDocuments()
    for (const docRef of docRefs) {
        const snapshot = await docRef.get()
        const data = snapshot.data()
        if (data !== undefined) {
            total += data.rating
            numRatings++
        }
    }
    const avgRating = total / numRatings

    const restaurantRef = restaurantRatingsRef.parent
        console.log(`${restaurantRef.path} now has ${numRatings} ratings with a ${avgRating} average`)
    await restaurantRef.update({
        avgRating: avgRating,
        numRatings: numRatings
    })
}
/*exports.myFunctionName = functions.firestore
    .document('users/marie').onWrite((change, context) => {
        // ... Your code here
    });*/
/*const data = {
    stringExample: 'Hello, World!',
    booleanExample: true,
    numberExample: 3.14159265,
    dateExample: admin.firestore.Timestamp.fromDate(new Date('December 10, 1815')),
    arrayExample: [5, true, 'hello'],
    nullExample: null,
    objectExample: {
        a: 5,
        b: true
    }
};

const res =  db.collection('beacons').doc(
    'VovDCygBGbMxRh2lekBt').set(data);*/


/*// // ejemplo HTTP function request- response
exports.helloWorld = functions.https.onRequest((request, response) => {
functions.logger.info("Hello logs!", {structuredData: true});
response.send("Hello from Firebase!");
});*/

//ejemplo Callable functions
/*
exports.hello = functions.https.onCall((data,context) => {
    return
    {
        response: "hello" + data.message
    }
});
export const prueba = functions.https.onCall(async(data,context) => {
    if (!context.auth)
    {
        throw new functions.https.HttpsError('unauthenticated', 'The user is not authenticated')
    }
    const uid= context.auth.uid
    console.log("user" + uid + "requested a random tip")
})*/
//function añadir usuario en la bbdd

