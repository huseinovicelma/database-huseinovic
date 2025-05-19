const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { connectToDatabase } = require('./config/db');

// Importazione delle routes
const utentiRoutes = require('./routes/utenti');
const spettacoliRoutes = require('./routes/spettacoli');
const bigliettiRoutes = require('./routes/biglietti');
const abbonamentiRoutes = require('./routes/abbonamenti');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Test della connessione al database
app.get('/test-db', async (req, res) => {
  try {
    const db = await connectToDatabase();
    await db.query('SELECT 1');
    res.status(200).json({ message: 'Connessione al database riuscita!' });
  } catch (error) {
    console.error('Errore di connessione al database:', error);
    res.status(500).json({ error: 'Errore di connessione al database' });
  }
});

// Routes
app.use('/api/utenti', utentiRoutes);
app.use('/api/spettacoli', spettacoliRoutes);
app.use('/api/biglietti', bigliettiRoutes);
app.use('/api/abbonamenti', abbonamentiRoutes);

// Route di base
app.get('/', (req, res) => {
  res.json({ message: 'Benvenuto all\'API di Gestione Teatro' });
});

// Avvio del server
app.listen(PORT, () => {
  console.log(`Server in esecuzione sulla porta ${PORT}`);
});

module.exports = app;