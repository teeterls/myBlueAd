// firebase admin sdk
const admin= require('firebase-admin');
TODO añadir nuevo servicio SDK
const serviceAccount = require('./mybluead-tfg-firebase-adminsdk-ekd0h-6817f10073.json');
admin.initializeApp({ credential: admin.credential.cert(serviceAccount)
});
//instancia cloud firestore -> bbdd en tiempo real
const db= admin.firestore();

getQuote();
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;

function getQuote() {
  const quoteData = {
    quote: "random",
    author: "String"
  };
  return db.collection("sampleData").doc("ins").set(quoteData).then(() => {
    console.log("new quote was written to the database");})
}
