USE GestioneTeatro;

-- Trigger per applicare lo sconto in base all'abbonamento
DELIMITER $$
CREATE TRIGGER check_abbonamento
BEFORE INSERT ON Biglietto
FOR EACH ROW
BEGIN
    DECLARE abbonamento_valido INT DEFAULT 0;
    DECLARE sconto DECIMAL(5,2) DEFAULT 0.40; -- Sconto fisso del 40%
    
    SELECT COUNT(*) INTO abbonamento_valido
    FROM Abbonamento
    WHERE utente = NEW.utente
    AND CURDATE() BETWEEN dataEmissione AND dataScadenza
    LIMIT 1;

    IF abbonamento_valido > 0 THEN
        SET NEW.prezzo = NEW.prezzo * (1 - sconto);
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER check_posto_disponibile
BEFORE INSERT ON Biglietto
FOR EACH ROW
BEGIN
    DECLARE posto_occupato INT DEFAULT 0;

    SELECT COUNT(*) INTO posto_occupato
    FROM Biglietto
    WHERE spettacolo = NEW.spettacolo AND posto = NEW.posto;

    IF posto_occupato > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il posto selezionato è già occupato per questo spettacolo';
    END IF;
END $$
DELIMITER ;

-- Trigger per controllare la disponibilità della sala
DELIMITER $$
CREATE TRIGGER check_sala_disponibile
BEFORE INSERT ON Spettacolo
FOR EACH ROW
BEGIN
    DECLARE sala_occupata INT DEFAULT 0;
    DECLARE fine_spettacolo DATETIME;

    SET fine_spettacolo = ADDTIME(NEW.dataOra, NEW.durata);
    
    SELECT COUNT(*) INTO sala_occupata
    FROM Spettacolo
    WHERE sala = NEW.sala
    AND (
        -- Verifica sovrapposizione: il nuovo spettacolo inizia durante un altro spettacolo
        (NEW.dataOra BETWEEN dataOra AND ADDTIME(dataOra, durata))
        OR
        -- Verifica sovrapposizione: il nuovo spettacolo finisce durante un altro spettacolo
        (fine_spettacolo BETWEEN dataOra AND ADDTIME(dataOra, durata))
        OR
        -- Verifica sovrapposizione: il nuovo spettacolo copre completamente un altro spettacolo
        (NEW.dataOra <= dataOra AND fine_spettacolo >= ADDTIME(dataOra, durata))
    );
    
    IF sala_occupata > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala è già occupata in questo orario';
    END IF;
END $$
DELIMITER ;