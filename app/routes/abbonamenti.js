const express = require('express');
const router = express.Router();
const { connectToDatabase } = require('../config/db');

// GET tutti gli abbonamenti
router.get('/', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [abbonamenti] = await db.query(`
      SELECT a.*, u.nome, u.cognome
      FROM Abbonamento a
      JOIN Utente u ON a.utente = u.idUtente
      ORDER BY a.dataScadenza DESC
    `);
    res.status(200).json(abbonamenti);
  } catch (error) {
    console.error('Errore nel recupero degli abbonamenti:', error);
    res.status(500).json({ error: 'Errore nel recupero degli abbonamenti' });
  }
});

// GET abbonamenti per utente
router.get('/utente/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [abbonamenti] = await db.query(`
      SELECT *
      FROM Abbonamento
      WHERE utente = ?
      ORDER BY dataScadenza DESC
    `, [req.params.id]);
    res.status(200).json(abbonamenti);
  } catch (error) {
    console.error('Errore nel recupero degli abbonamenti dell\'utente:', error);
    res.status(500).json({ error: 'Errore nel recupero degli abbonamenti dell\'utente' });
  }
});

// GET abbonamenti attivi
router.get('/attivi', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [abbonamenti] = await db.query(`
      SELECT a.*, u.nome, u.cognome
      FROM Abbonamento a
      JOIN Utente u ON a.utente = u.idUtente
      WHERE CURDATE() BETWEEN a.dataEmissione AND a.dataScadenza
      ORDER BY a.dataScadenza
    `);
    res.status(200).json(abbonamenti);
  } catch (error) {
    console.error('Errore nel recupero degli abbonamenti attivi:', error);
    res.status(500).json({ error: 'Errore nel recupero degli abbonamenti attivi' });
  }
});

// POST nuovo abbonamento (usando stored procedure)
router.post('/', async (req, res) => {
  const { idUtente, tipo } = req.body;
  
  if (!idUtente || !tipo) {
    return res.status(400).json({ error: 'Tutti i campi sono obbligatori' });
  }
  
  try {
    const db = await connectToDatabase();
    const [result] = await db.query(
      'CALL sp_acquistaAbbonamento(?, ?, @risultato)',
      [idUtente, tipo]
    );
    
    const [output] = await db.query('SELECT @risultato as risultato');
    res.status(201).json({ message: output[0].risultato || 'Abbonamento acquistato con successo' });
  } catch (error) {
    console.error('Errore nell\'acquisto dell\'abbonamento:', error);
    res.status(500).json({ error: 'Errore nell\'acquisto dell\'abbonamento' });
  }
});

module.exports = router;