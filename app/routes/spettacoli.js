const express = require('express');
const router = express.Router();
const { connectToDatabase } = require('../config/db');

router.get('/', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [spettacoli] = await db.query(`
      SELECT * FROM v_spettacoli
    `);
    res.status(200).json(spettacoli);
  } catch (error) {
    console.error('Errore nel recupero degli spettacoli:', error);
    res.status(500).json({ error: 'Errore nel recupero degli spettacoli' });
  }
});

router.get('/data/:data', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [spettacoli] = await db.query('CALL sp_visualizzaSpettacoliGiornata(?)', [req.params.data]);
    res.status(200).json(spettacoli[0]);
  } catch (error) {
    console.error('Errore nel recupero degli spettacoli per data:', error);
    res.status(500).json({ error: 'Errore nel recupero degli spettacoli per data' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [spettacoli] = await db.query(`
      SELECT s.*, sa.nome AS nomeSala, ct.nome AS nomeCompagnia 
      FROM Spettacolo s
      JOIN Sala sa ON s.sala = sa.numeroSala
      JOIN CompagniaTeatrale ct ON s.compagnia = ct.idCompagnia
      WHERE s.idSpettacolo = ?
    `, [req.params.id]);
    
    if (spettacoli.length === 0) {
      return res.status(404).json({ error: 'Spettacolo non trovato' });
    }
    
    res.status(200).json(spettacoli[0]);
  } catch (error) {
    console.error('Errore nel recupero dello spettacolo:', error);
    res.status(500).json({ error: 'Errore nel recupero dello spettacolo' });
  }
});

router.get('/:id/posti-disponibili', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [posti] = await db.query('CALL sp_visualizzaPostiDisponibili(?)', [req.params.id]);
    res.status(200).json(posti[0]);
  } catch (error) {
    console.error('Errore nel recupero dei posti disponibili:', error);
    res.status(500).json({ error: 'Errore nel recupero dei posti disponibili' });
  }
});

router.get('/:id/numero-posti-liberi', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [result] = await db.query('SELECT fn_contaPostiDisponibili(?) AS postiLiberi', [req.params.id]);
    res.status(200).json({ postiLiberi: result[0].postiLiberi });
  } catch (error) {
    console.error('Errore nel conteggio dei posti liberi:', error);
    res.status(500).json({ error: 'Errore nel conteggio dei posti liberi' });
  }
});

router.post('/', async (req, res) => {
  const { idCompagnia, titolo, genere, durata, idSala, dataOra } = req.body;
  
  if (!idCompagnia || !titolo || !genere || !durata || !idSala || !dataOra) {
    return res.status(400).json({ error: 'Tutti i campi sono obbligatori' });
  }
  
  try {
    const db = await connectToDatabase();
    const [result] = await db.query(
      'CALL sp_inserisciSpettacolo(?, ?, ?, ?, ?, ?, @risultato)',
      [idCompagnia, titolo, genere, durata, idSala, dataOra]
    );
    
    const [output] = await db.query('SELECT @risultato as risultato');
    res.status(201).json({ message: output[0].risultato || 'Spettacolo creato con successo' });
  } catch (error) {
    console.error('Errore nella creazione dello spettacolo:', error);
    if (error.message.includes('La sala è già occupata')) {
      return res.status(400).json({ error: 'La sala è già occupata in questo orario' });
    }
    res.status(500).json({ error: 'Errore nella creazione dello spettacolo' });
  }
});

module.exports = router;