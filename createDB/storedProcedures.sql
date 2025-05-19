USE GestioneTeatro;

-- Creazione procedura per inserire un nuovo utente 
DELIMITER $$
CREATE PROCEDURE sp_inserisciUtente(
    IN p_nome VARCHAR(30),
    IN p_cognome VARCHAR(30),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(15)
) 
BEGIN 
    INSERT INTO Utente (nome, cognome, email, telefono)
    VALUES (p_nome, p_cognome, p_email, p_telefono);
END $$
DELIMITER ;


-- Creazione procedura per acquistare un biglietto 
DELIMITER $$
CREATE PROCEDURE sp_acquistaBiglietto(
    IN p_idUtente INT(11),
    IN p_idSpettacolo INT(11),
    IN p_posto INT(11),
    OUT p_risultato VARCHAR(50)
)
BEGIN
    DECLARE v_postoOccupato INT(11) DEFAULT 0;
    DECLARE v_prezzoBase DECIMAL(10,2);
    DECLARE v_idTipoPosto INT(11);
    DECLARE v_utenteEsiste INT DEFAULT 0;
    DECLARE v_spettacoloEsiste INT DEFAULT 0;
    DECLARE v_postoEsiste INT DEFAULT 0; 

    -- controllo se l'utente esiste 
    SELECT COUNT(*) INTO v_utenteEsiste FROM Utente WHERE idUtente = p_idUtente;
    IF v_utenteEsiste = 0 THEN
        SET p_risultato = 'Utente non trovato';
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;

    -- Verifica che lo spettacolo esista
    SELECT COUNT(*) INTO v_spettacoloEsiste FROM Spettacolo WHERE idSpettacolo = p_idSpettacolo;
    IF v_spettacoloEsiste = 0 THEN
        SET p_risultato = 'Spettacolo non trovato';     
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Spettacolo non trovato';
    END IF;

    -- Verifica che il posto esista
    SELECT COUNT(*) INTO v_postoEsiste FROM Posto WHERE idPosto = p_idPosto;
    IF v_postoEsiste = 0 THEN
        SET p_risultato = 'Posto non trovato'; 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Posto non trovato';
    END IF;

     -- Ottieni il tipo di posto e il prezzo base
    SELECT tipo INTO v_idTipoPosto FROM Posto WHERE idPosto = p_idPosto;
    SELECT prezzoBase INTO v_prezzoBase FROM TipoPosto WHERE codiceTipo = v_idTipoPosto;

    INSERT INTO Biglietto (prezzo, dataEmissione, utente, spettacolo, posto)
    VALUES (v_prezzoBase, CURDATE(), p_idUtente, p_idSpettacolo, p_idPosto);
    SET p_risultato = 'Biglietto creato con successo';
END $$
DELIMITER ;

-- Creazione procedura per acquistare un abbonamento
DELIMITER $$
CREATE PROCEDURE sp_acquistaAbbonamento(
    IN p_idUtente INT(11),
    IN p_tipo VARCHAR(30),
    OUT p_risultato VARCHAR(100)
)
BEGIN
    DECLARE v_prezzo DECIMAL(10,2);
    DECLARE v_dataScadenza DATE;
    DECLARE v_durataMesi INT;
    
    -- Calcola il prezzo e la durata dell'abbonamento in base al tipo
    CASE p_tipo
        WHEN 'Mensile' THEN 
            SET v_prezzo = 50.00;
            SET v_durataMesi = 1;
        WHEN 'Semestrale' THEN 
            SET v_prezzo = 80.00;
            SET v_durataMesi = 6;
        WHEN 'Annuale' THEN 
            SET v_prezzo = 120.00;
            SET v_durataMesi = 12;
        ELSE 
            SET v_prezzo = 50.00; -- Default
            SET v_durataMesi = 1; -- Default
    END CASE;
    
    -- Calcola la data di scadenza
    SET v_dataScadenza = DATE_ADD(CURDATE(), INTERVAL v_durataMesi MONTH);
    
    -- Inserisci il nuovo abbonamento
    INSERT INTO Abbonamento (dataEmissione, dataScadenza, prezzo, tipo, utente)
    VALUES (CURDATE(), v_dataScadenza, v_prezzo, p_tipo, p_idUtente);
    
    SET p_risultato = CONCAT('Abbonamento ', p_tipo, ' acquistato con successo. Scadenza: ', v_dataScadenza);
END $$
DELIMITER ;


-- Creazione procedura per visualizzare gli spettacoli della giornata
DELIMITER $$
CREATE PROCEDURE sp_visualizzaSpettacoliGiornata(
    IN p_data DATE
)
BEGIN
    SELECT s.idSpettacolo, s.titolo, s.genere, s.dataOra, s.durata, 
           sa.nome AS nomeSala, ct.nome AS nomeCompagnia
    FROM Spettacolo s
    JOIN Sala sa ON s.sala = sa.numeroSala
    JOIN CompagniaTeatrale ct ON s.compagnia = ct.idCompagnia
    WHERE DATE(s.dataOra) = p_data
    ORDER BY s.dataOra;
END $$
DELIMITER ;

-- Procedura per visualizzare i posti disponibili per uno spettacolo
DELIMITER $$
CREATE PROCEDURE sp_visualizzaPostiDisponibili(
    IN p_idSpettacolo INT
)
BEGIN
    -- Seleziona tutti i posti disponibili per lo spettacolo
    SELECT p.idPosto, p.fila, p.numero, tp.tipo, tp.prezzoBase, s.nome AS nomeSala
    FROM Posto p
    JOIN Sala s ON p.sala = s.numeroSala
    JOIN TipoPosto tp ON p.tipo = tp.codiceTipo
    JOIN Spettacolo sp ON p.sala = sp.sala
    WHERE sp.idSpettacolo = p_idSpettacolo
    AND p.idPosto NOT IN (
        SELECT posto FROM Biglietto WHERE spettacolo = p_idSpettacolo
    )
    ORDER BY p.fila, p.numero;
END $$
DELIMITER ;

-- Creazione procedura per inserire uno spettacolo 
DELIMITER $$
CREATE PROCEDURE sp_inserisciSpettacolo(
    IN p_idCompagnia INT(11),
    IN p_titolo VARCHAR(50),
    IN p_genere VARCHAR(30),
    IN p_durata TIME,
    IN p_idSala INT(11),
    IN p_dataOra DATETIME,
    OUT p_risultato VARCHAR(100)
)
BEGIN
    DECLARE v_compagniaEsiste INT DEFAULT 0;
    DECLARE v_salaEsiste INT DEFAULT 0;
    
    -- Verifica che la compagnia esista
    SELECT COUNT(*) INTO v_compagniaEsiste FROM CompagniaTeatrale WHERE idCompagnia = p_idCompagnia;
    IF v_compagniaEsiste = 0 THEN
        SET p_risultato = 'Compagnia teatrale non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Compagnia teatrale non trovata';
    END IF;
    
    -- Verifica che la sala esista
    SELECT COUNT(*) INTO v_salaEsiste FROM Sala WHERE numeroSala = p_idSala;
    IF v_salaEsiste = 0 THEN
        SET p_risultato = 'Sala non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sala non trovata';
    END IF;
    
    -- Inserisci il nuovo spettacolo
    INSERT INTO Spettacolo (titolo, genere, dataOra, durata, sala, compagnia)
    VALUES (p_titolo, p_genere, p_dataOra, p_durata, p_idSala, p_idCompagnia);
    
    SET p_risultato = CONCAT('Spettacolo "', p_titolo, '" programmato con successo per il ', DATE_FORMAT(p_dataOra, '%d/%m/%Y %H:%i'));
END $$
DELIMITER ;

-- Creazione procedura per eliminare un utente
DELIMITER $$
CREATE PROCEDURE sp_eliminaUtente(
    IN p_idUtente INT,
    OUT p_risultato VARCHAR(100)
)
BEGIN
    DECLARE v_countBiglietti INT DEFAULT 0;
    DECLARE v_countAbbonamenti INT DEFAULT 0;
    
    -- Verifica se l'utente esiste
    IF NOT EXISTS (SELECT 1 FROM Utente WHERE idUtente = p_idUtente) THEN
        SET p_risultato = 'Utente non trovato';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;
    
    -- Conta i biglietti associati all'utente
    SELECT COUNT(*) INTO v_countBiglietti FROM Biglietto WHERE utente = p_idUtente;
    
    -- Conta gli abbonamenti associati all'utente
    SELECT COUNT(*) INTO v_countAbbonamenti FROM Abbonamento WHERE utente = p_idUtente;
    
    -- Elimina i biglietti associati all'utente
    DELETE FROM Biglietto WHERE utente = p_idUtente;
    
    -- Elimina gli abbonamenti associati all'utente
    DELETE FROM Abbonamento WHERE utente = p_idUtente;
    
    -- Elimina l'utente
    DELETE FROM Utente WHERE idUtente = p_idUtente;
    
    SET p_risultato = CONCAT('Utente eliminato con successo. Eliminati anche ', 
                            v_countBiglietti, ' biglietti e ', 
                            v_countAbbonamenti, ' abbonamenti associati.');
END $$
DELIMITER ;
