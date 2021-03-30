//  utilizar modulo functions
const functions = require("firebase-functions");
// admin sdk
const admin = require("firebase-admin");

admin.initializeApp();

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
});*/
//function añadir usuario en la bbdd
export const prueba = functions.https.onCall(async(data,context) => {
    if (!context.auth)
    {
        throw new functions.https.HttpsError('unauthenticated', 'The user is not authenticated')
    }
    const uid= context.auth.uid
    console.log("user" + uid + "requested a random tip")
})
