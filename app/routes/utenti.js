const express = require('express');
const router = express.Router();
const { connectToDatabase } = require('../config/db');

// GET tutti gli utenti
router.get('/', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [utenti] = await db.query('SELECT * FROM Utente');
    res.status(200).json(utenti);
  } catch (error) {
    console.error('Errore nel recupero degli utenti:', error);
    res.status(500).json({ error: 'Errore nel recupero degli utenti' });
  }
});

// GET utente per ID
router.get('/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const [utenti] = await db.query('SELECT * FROM Utente WHERE idUtente = ?', [req.params.id]);
    
    if (utenti.length === 0) {
      return res.status(404).json({ error: 'Utente non trovato' });
    }
    
    res.status(200).json(utenti[0]);
  } catch (error) {
    console.error('Errore nel recupero dell\'utente:', error);
    res.status(500).json({ error: 'Errore nel recupero dell\'utente' });
  }
});

// POST nuovo utente
router.post('/', async (req, res) => {
  const { nome, cognome, email, telefono } = req.body;
  
  if (!nome || !cognome || !email) {
    return res.status(400).json({ error: 'Nome, cognome e email sono campi obbligatori' });
  }
  
  try {
    const db = await connectToDatabase();
    await db.query('CALL sp_inserisciUtente(?, ?, ?, ?)', [nome, cognome, email, telefono]);
    res.status(201).json({ message: 'Utente creato con successo' });
  } catch (error) {
    console.error('Errore nella creazione dell\'utente:', error);
    res.status(500).json({ error: 'Errore nella creazione dell\'utente' });
  }
});

// PUT aggiorna utente
router.put('/:id', async (req, res) => {
  const { nome, cognome, email, telefono } = req.body;
  const id = req.params.id;
  
  try {
    const db = await connectToDatabase();
    const [result] = await db.query(
      'UPDATE Utente SET nome = ?, cognome = ?, email = ?, telefono = ? WHERE idUtente = ?',
      [nome, cognome, email, telefono, id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Utente non trovato' });
    }
    
    res.status(200).json({ message: 'Utente aggiornato con successo' });
  } catch (error) {
    console.error('Errore nell\'aggiornamento dell\'utente:', error);
    res.status(500).json({ error: 'Errore nell\'aggiornamento dell\'utente' });
  }
});

// DELETE utente (usando stored procedure)
router.delete('/:id', async (req, res) => {
  try {
    const db = await connectToDatabase();
    const id = req.params.id;
    
    // Utilizzo della stored procedure per eliminare l'utente e i suoi riferimenti
    const [result] = await db.query('CALL sp_eliminaUtente(?, @risultato)', [id]);
    const [output] = await db.query('SELECT @risultato as messaggio');
    
    if (output[0].messaggio && output[0].messaggio.includes('non trovato')) {
      return res.status(404).json({ error: 'Utente non trovato' });
    }
    
    res.status(200).json({ message: output[0].messaggio || 'Utente eliminato con successo' });
  } catch (error) {
    console.error('Errore nell\'eliminazione dell\'utente:', error);
    
    // Gestione specifica degli errori
    if (error.message && error.message.includes('non trovato')) {
      return res.status(404).json({ error: 'Utente non trovato' });
    }
    
    res.status(500).json({ error: 'Errore nell\'eliminazione dell\'utente: ' + error.message });
  }
});

module.exports = router;