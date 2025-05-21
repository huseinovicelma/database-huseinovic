const express = require('express');
const router = express.Router();
const { connectToDatabase } = require('../config/db');

// GET tutti i biglietti
router.get('/', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [biglietti] = await db.query(`
      SELECT * FROM v_biglietti
    `);
    res.status(200).json(biglietti);
  } catch (error) {
    console.error('Errore nel recupero dei biglietti:', error);
    res.status(500).json({ error: 'Errore nel recupero dei biglietti' });
  }
});

// GET biglietti per utente
router.get('/utente/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [biglietti] = await db.query(`
      SELECT b.*, s.titolo, s.dataOra, p.fila, p.numero
      FROM Biglietto b
      JOIN Spettacolo s ON b.spettacolo = s.idSpettacolo
      JOIN Posto p ON b.posto = p.idPosto
      WHERE b.utente = ?
      ORDER BY s.dataOra
    `, [req.params.id]);
    res.status(200).json(biglietti);
  } catch (error) {
    console.error('Errore nel recupero dei biglietti dell\'utente:', error);
    res.status(500).json({ error: 'Errore nel recupero dei biglietti dell\'utente' });
  }
});

// GET biglietti per spettacolo
router.get('/spettacolo/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [biglietti] = await db.query(`
      SELECT b.*, u.nome, u.cognome, p.fila, p.numero
      FROM Biglietto b
      JOIN Utente u ON b.utente = u.idUtente
      JOIN Posto p ON b.posto = p.idPosto
      WHERE b.spettacolo = ?
    `, [req.params.id]);
    res.status(200).json(biglietti);
  } catch (error) {
    console.error('Errore nel recupero dei biglietti dello spettacolo:', error);
    res.status(500).json({ error: 'Errore nel recupero dei biglietti dello spettacolo' });
  }
});

// POST nuovo biglietto 
router.post('/', async (req, res) => {
  const { idUtente, idSpettacolo, idPosto } = req.body;
  
  if (!idUtente || !idSpettacolo || !idPosto) {
    return res.status(400).json({ error: 'Tutti i campi sono obbligatori' });
  }
  
  try {
    const db = await connectToDatabase();
    const [result] = await db.query(
      'CALL sp_acquistaBiglietto(?, ?, ?, @risultato)',
      [idUtente, idSpettacolo, idPosto]
    );
    
    const [output] = await db.query('SELECT @risultato as risultato');
    res.status(201).json({ message: output[0].risultato || 'Biglietto acquistato con successo' });
  } catch (error) {
    console.error('Errore nell\'acquisto del biglietto:', error);
    if (error.message.includes('posto selezionato è già occupato')) {
      return res.status(400).json({ error: 'Il posto selezionato è già occupato per questo spettacolo' });
    }
    res.status(500).json({ error: 'Errore nell\'acquisto del biglietto' });
  }
});

module.exports = router;