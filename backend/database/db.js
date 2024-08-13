var mysql2 = require("mysql2");

var db = mysql2.createConnection({
  host: "127.0.0.1",
  port: 3306,
  database: "mcc_qualif",
  user: "root",
  password: "",
});

db.connect();

module.exports = db;
