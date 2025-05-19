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