var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var app = express();

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname + '/public'));

var connection = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  database: process.env.MYSQL_DATABASE,
  password: process.env.MYSQL_PASSWORD,
});

app.get('/', function (req, res) {
  // Find count of users in DB
  var q = 'SELECT COUNT(*) AS count FROM users';
  connection.query(q, function (err, results) {
    if (err) throw err;
    var count = results[0].count;
    res.render('home', { count: count });
  });
});

app.post('/register', function (req, res) {
  var person = {
    email: req.body.email,
  };
  connection.query('INSERT INTO users SET ?', person, function (err, result) {
    if (err) throw err;
    res.redirect('/');
  });
});

app.listen(3000, function () {
  console.log('Server running on 3000!');
});
