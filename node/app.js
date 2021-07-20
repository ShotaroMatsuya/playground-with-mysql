const faker = require('faker');
const mysql = require('mysql');

const connection = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  database: process.env.MYSQL_DATABASE,
  password: process.env.MYSQL_PASSWORD,
});

// console.log(faker.internet.email());
// console.log(faker.date.past());

// function generateAddress() {
//   console.log(faker.address.streetAddress());
//   console.log(faker.address.city());
//   console.log(faker.address.state());
// }

// Selecting data
// const q = 'SELECT COUNT(*) AS total FROM users';
// connection.query(q, function (error, results, fields) {
//   if (error) throw error;
//   console.log(results[0].total);
// });
// Inserting data
// const q = 'INSERT INTO users(email) VALUES("wyatt_the_dog@gmail.com")';
// connection.query(q, function (error, results, fields) {
//   if (error) throw error;
//   console.log(results);
// });
// Inserting data take 2
// const person = { email: faker.internet.email(), created_at: faker.date.past() };

// const end_result = connection.query(
//   'INSERT INTO users SET ?',
//   person,
//   function (err, result) {
//     if (err) throw err;
//     console.log(result);
//   }
// );
// console.log(end_result.sql);

// connection.end();

// console.log(faker.date.past());
// 2020-09-03T15:04:46.312Z

// Insert lots of data!!!
const data = [];
for (let i = 0; i < 500; i++) {
  data.push([faker.internet.email(), faker.date.past()]);
}
console.log(data);
const q = 'INSERT INTO users(email,created_at) VALUES ?';
connection.query(q, [data], function (err, result) {
  console.log(err);
  console.log(result);
});
connection.end();