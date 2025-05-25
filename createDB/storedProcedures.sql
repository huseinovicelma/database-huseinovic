USE GestioneTeatro;

DELIMITER $$
CREATE PROCEDURE sp_inserisciUtente(
    IN in_nome VARCHAR(30),
    IN in_cognome VARCHAR(30),
    IN in_email VARCHAR(50),
    IN in_telefono VARCHAR(15)
) 
BEGIN 
    INSERT INTO Utente (nome, cognome, email, telefono)
    VALUES (in_nome, in_cognome, in_email, in_telefono);
END $$
DELIMITER ;

CREATE PROCEDURE sp_acquistaBiglietto(
    IN in_idUtente INT(11),
    IN in_idSpettacolo INT(11),
    IN in_idPosto INT(11),
    OUT risultato VARCHAR(50)
)
BEGIN
    DECLARE postoOccupato INT(11) DEFAULT 0;
    DECLARE prezzoPosto DECIMAL(10,2);
    DECLARE idTipoPosto INT(11);
    DECLARE utenteEsiste INT DEFAULT 0;
    DECLARE spettacoloEsiste INT DEFAULT 0;
    DECLARE postoEsiste INT DEFAULT 0; 

    SELECT COUNT(*) INTO utenteEsiste FROM Utente WHERE idUtente = in_idUtente;
    IF utenteEsiste = 0 THEN
        SET risultato = 'Utente non trovato';
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;

    SELECT COUNT(*) INTO spettacoloEsiste FROM Spettacolo WHERE idSpettacolo = in_idSpettacolo;
    IF spettacoloEsiste = 0 THEN
        SET risultato = 'Spettacolo non trovato';     
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Spettacolo non trovato';
    END IF;

    SELECT COUNT(*) INTO postoEsiste FROM Posto WHERE idPosto = in_idPosto;
    IF postoEsiste = 0 THEN
        SET risultato = 'Posto non trovato'; 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Posto non trovato';
    END IF;

    SELECT tipo INTO idTipoPosto FROM Posto WHERE idPosto = in_idPosto;
    SELECT prezzoBase INTO prezzoPosto FROM TipoPosto WHERE codiceTipo = idTipoPosto;

    INSERT INTO Biglietto (prezzo, dataEmissione, utente, spettacolo, posto)
    VALUES (prezzoPosto, CURDATE(), in_idUtente, in_idSpettacolo, in_idPosto);
    SET risultato = 'Biglietto creato con successo';
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_acquistaAbbonamento(
    IN in_idUtente INT(11),
    IN in_tipo VARCHAR(30),
    OUT risultato VARCHAR(100)
)
BEGIN
    DECLARE prezzoAbbonamento DECIMAL(10,2);
    DECLARE scadenza DATE;
    DECLARE durataMesi INT;

    CASE in_tipo
        WHEN 'Mensile' THEN 
            SET prezzoAbbonamento = 50.00;
            SET durataMesi = 1;
        WHEN 'Semestrale' THEN 
            SET prezzoAbbonamento = 80.00;
            SET durataMesi = 6;
        WHEN 'Annuale' THEN 
            SET prezzoAbbonamento = 120.00;
            SET durataMesi = 12;
        ELSE 
            SET prezzoAbbonamento = 50.00; 
            SET durataMesi = 1; 
    END CASE;

    SET scadenza = DATE_ADD(CURDATE(), INTERVAL durataMesi MONTH);

    INSERT INTO Abbonamento (dataEmissione, dataScadenza, prezzo, tipo, utente)
    VALUES (CURDATE(), scadenza, prezzoAbbonamento, in_tipo, in_idUtente);
    
    SET risultato = CONCAT('Abbonamento ', in_tipo, ' acquistato con successo. Scadenza: ', scadenza);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_visualizzaSpettacoliGiornata(
    IN in_data DATE
)
BEGIN
    SELECT s.idSpettacolo, s.titolo, s.genere, s.dataOra, s.durata, 
           sa.nome AS nomeSala, ct.nome AS nomeCompagnia
    FROM Spettacolo s
    JOIN Sala sa ON s.sala = sa.numeroSala
    JOIN CompagniaTeatrale ct ON s.compagnia = ct.idCompagnia
    WHERE DATE(s.dataOra) = in_data
    ORDER BY s.dataOra;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_visualizzaPostiDisponibili(
    IN in_idSpettacolo INT
)
BEGIN
    SELECT p.idPosto, p.fila, p.numero, tp.tipo, tp.prezzoBase, s.nome AS nomeSala
    FROM Posto p
    JOIN Sala s ON p.sala = s.numeroSala
    JOIN TipoPosto tp ON p.tipo = tp.codiceTipo
    JOIN Spettacolo sp ON p.sala = sp.sala
    WHERE sp.idSpettacolo = in_idSpettacolo
    AND p.idPosto NOT IN (
        SELECT posto FROM Biglietto WHERE spettacolo = in_idSpettacolo
    )
    ORDER BY p.fila, p.numero;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_inserisciSpettacolo(
    IN in_idCompagnia INT(11),
    IN in_titolo VARCHAR(50),
    IN in_genere VARCHAR(30),
    IN in_durata TIME,
    IN in_idSala INT(11),
    IN in_dataOra DATETIME,
    OUT risultato VARCHAR(100)
)
BEGIN
    DECLARE compagniaEsiste INT DEFAULT 0;
    DECLARE salaEsiste INT DEFAULT 0;
    
    SELECT COUNT(*) INTO compagniaEsiste FROM CompagniaTeatrale WHERE idCompagnia = in_idCompagnia;
    IF compagniaEsiste = 0 THEN
        SET risultato = 'Compagnia teatrale non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Compagnia teatrale non trovata';
    END IF;
    
    SELECT COUNT(*) INTO salaEsiste FROM Sala WHERE numeroSala = in_idSala;
    IF salaEsiste = 0 THEN
        SET risultato = 'Sala non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sala non trovata';
    END IF;
    
    INSERT INTO Spettacolo (titolo, genere, dataOra, durata, sala, compagnia)
    VALUES (in_titolo, in_genere, in_dataOra, in_durata, in_idSala, in_idCompagnia);
    
    SET risultato = CONCAT('Spettacolo "', in_titolo, '" programmato con successo per il ', DATE_FORMAT(in_dataOra, '%d/%m/%Y %H:%i'));
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_eliminaUtente(
    IN in_idUtente INT(11),
    OUT risultato VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Utente WHERE idUtente = in_idUtente) THEN
        SET risultato = 'Utente non trovato';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;
    DELETE FROM Utente WHERE idUtente = in_idUtente;
    SET risultato = 'Utente eliminato con successo.';
END $$
DELIMITER ;
