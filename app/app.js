const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const utentiRoutes = require('./routes/utenti');
const spettacoliRoutes = require('./routes/spettacoli');
const bigliettiRoutes = require('./routes/biglietti');
const abbonamentiRoutes = require('./routes/abbonamenti');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api/utenti', utentiRoutes);
app.use('/api/spettacoli', spettacoliRoutes);
app.use('/api/biglietti', bigliettiRoutes);
app.use('/api/abbonamenti', abbonamentiRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'Gestione Teatro' });
});

app.listen(PORT, () => {
  console.log(`Server in esecuzione sulla porta ${PORT}`);
});

module.exports = app;