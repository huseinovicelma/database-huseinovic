require('dotenv').config();
const mysql = require('mysql2/promise');
let cachedDb;

module.exports = {
    connectToDatabase: async () => {
        if (cachedDb && cachedDb.state !== 'disconnected') {
            console.log('Existing cached connection found!');
            return cachedDb;
        }  
        console.log('Acquiring new DB connection...');
        try {
            const db = await mysql.createConnection({
                host: process.env.DB_HOST || 'mysql-db-huseinovic' || 'localhost',
                port: process.env.DB_PORT, 
                user: process.env.DB_USER,
                password: process.env.DB_PASSWORD,
                database: process.env.DB_NAME,
              });
            console.log('New MySQL connection established!');  
            cachedDb = db;
            return db;
        } catch (error) {
            console.error('Error acquiring DB connection!');
            console.error(error);
            throw error;
        }
    },
};