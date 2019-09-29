const mysql = require('promise-mysql');

let pool = null;

exports.createPool = async function () {
    pool = mysql.createPool({
        multipleStatements: true,
        host: process.env.TRAVEL_DB_HOST,
        user: process.env.TRAVEL_DB_USER,
        password: process.env.TRAVEL_DB_PASSWORD,
        database: process.env.TRAVEL_DB_DATABASE
    });
};

exports.getPool = function () {
    return pool;
};
