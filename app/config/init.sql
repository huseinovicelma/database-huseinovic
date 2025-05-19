CREATE DATABASE IF NOT EXISTS GestioneTeatro;

USE GestioneTeatro;

CREATE TABLE IF NOT EXISTS Utente (
    idUtente INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    cognome VARCHAR(30) NOT NULL,
    email VARCHAR(50),
    telefono VARCHAR(15),
    PRIMARY KEY (idUtente)
);

CREATE TABLE IF NOT EXISTS TipoPosto (
    codiceTipo INT(11) NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(30) NOT NULL,
    prezzoBase DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (codiceTipo)
);

CREATE TABLE IF NOT EXISTS Sala (
    numeroSala INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    capienza INT(11) NOT NULL,
    PRIMARY KEY (numeroSala)
);

CREATE TABLE IF NOT EXISTS CompagniaTeatrale (
    idCompagnia INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    annoFondazione YEAR NOT NULL,
    PRIMARY KEY (idCompagnia)   
);

CREATE TABLE IF NOT EXISTS Artista (
    idArtista INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    cognome VARCHAR(30) NOT NULL,
    dataNascita DATE NOT NULL,
    CF VARCHAR(16) NOT NULL,
    PRIMARY KEY (idArtista) 
);

CREATE TABLE IF NOT EXISTS Spettacolo (
    idSpettacolo INT(11) NOT NULL AUTO_INCREMENT,
    titolo VARCHAR(50) NOT NULL,
    genere VARCHAR(30) NOT NULL,
    dataOra DATETIME NOT NULL,
    durata TIME NOT NULL,
    sala INT(11) NOT NULL,
    compagnia INT(11) NOT NULL,
    PRIMARY KEY (idSpettacolo),
    FOREIGN KEY (sala) REFERENCES Sala(numeroSala),
    FOREIGN KEY (compagnia) REFERENCES CompagniaTeatrale(idCompagnia)
);

CREATE TABLE IF NOT EXISTS Posto (
    idPosto INT(11) NOT NULL AUTO_INCREMENT,
    fila INT(11) NOT NULL,
    numero INT(11) NOT NULL,
    tipo INT(11) NOT NULL,
    sala INT(11) NOT NULL,
    PRIMARY KEY (idPosto),
    FOREIGN KEY (sala) REFERENCES Sala(numeroSala),
    FOREIGN KEY (tipo) REFERENCES TipoPosto(codiceTipo)
);

CREATE TABLE IF NOT EXISTS Abbonamento (
    codiceAbbonamento INT(11) NOT NULL AUTO_INCREMENT,
    dataEmissione DATE NOT NULL,
    dataScadenza DATE NOT NULL,   
    prezzo DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    utente INT(11) NOT NULL,
    PRIMARY KEY (codiceAbbonamento),
    FOREIGN KEY (utente) REFERENCES Utente(idUtente)
);

CREATE TABLE IF NOT EXISTS Biglietto (
    codiceBiglietto INT(11) NOT NULL AUTO_INCREMENT,
    prezzo DECIMAL(10,2) NOT NULL,
    dataEmissione DATE NOT NULL,
    utente INT(11) NOT NULL,
    spettacolo INT(11) NOT NULL,
    posto INT(11) NOT NULL,
    PRIMARY KEY (codiceBiglietto),
    FOREIGN KEY (utente) REFERENCES Utente(idUtente),
    FOREIGN KEY (spettacolo) REFERENCES Spettacolo(idSpettacolo),
    FOREIGN KEY (posto) REFERENCES Posto(idPosto)
);

CREATE TABLE IF NOT EXISTS MembroStaff (
    idMembro INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    cognome VARCHAR(30) NOT NULL,
    dataNascita DATE NOT NULL,
    CF VARCHAR(16) NOT NULL,
    ruolo VARCHAR(30) NOT NULL,
    sala INT(11) NOT NULL,
    PRIMARY KEY (idMembro),
    FOREIGN KEY (sala) REFERENCES Sala(numeroSala)
);

CREATE TABLE IF NOT EXISTS Contratto (
    codiceContratto INT(11) NOT NULL AUTO_INCREMENT,
    dataInizio DATE NOT NULL,
    dataFine DATE NOT NULL,
    ruoloContrattuale VARCHAR(30) NOT NULL,
    artista INT(11) NOT NULL,
    compagnia INT(11) NOT NULL,
    PRIMARY KEY (codiceContratto),
    FOREIGN KEY (artista) REFERENCES Artista(idArtista),
    FOREIGN KEY (compagnia) REFERENCES CompagniaTeatrale(idCompagnia) 
);


INSERT IGNORE INTO Utente (nome, cognome, email, telefono) VALUES
('Mario', 'Rossi', 'mario.rossi@email.com', '3331234567'),
('Giulia', 'Bianchi', 'giulia.bianchi@email.com', '3339876543'),
('Paolo', 'Verdi', 'paolo.verdi@email.com', '3351122334'),
('Laura', 'Neri', 'laura.neri@email.com', '3387654321'),
('Marco', 'Gialli', 'marco.gialli@email.com', '3391234567');


INSERT IGNORE INTO TipoPosto (tipo, prezzoBase) VALUES
('Platea', 30.00),
('Palco', 45.00),
('Galleria', 20.00),
('VIP', 60.00);


INSERT IGNORE INTO Sala (nome, capienza) VALUES
('Sala Principale', 200),
('Sala Piccola', 80),
('Sala Eventi', 150);

INSERT IGNORE INTO CompagniaTeatrale (nome, annoFondazione) VALUES
('Compagnia del Sole', 1995),
('Teatro Moderno', 2005),
('Artisti Uniti', 2010),
('Compagnia Classica', 1980);

 
INSERT IGNORE INTO Artista (nome, cognome, dataNascita, CF) VALUES
('Roberto', 'Benigni', '1952-10-27', 'BNGRRT52R27H901X'),
('Anna', 'Magnani', '1980-05-15', 'MGNNNA80E15H501Y'),
('Luca', 'Marinelli', '1984-10-22', 'MRNLCU84R22H501Z'),
('Sofia', 'Loren', '1975-03-10', 'LRNSFA75C10H501W'),
('Alessandro', 'Gassman', '1965-02-24', 'GSSLSN65B24H501K');


INSERT IGNORE INTO MembroStaff (nome, cognome, dataNascita, CF, ruolo, sala) VALUES
('Giuseppe', 'Verdi', '1985-07-12', 'VRDGPP85L12H501X', 'Direttore di Sala', 1),
('Maria', 'Rossi', '1990-03-25', 'RSSMRA90C25H501Y', 'Tecnico Luci', 1),
('Franco', 'Bianchi', '1978-11-30', 'BNCFNC78S30H501Z', 'Tecnico Audio', 2),
('Giovanna', 'Neri', '1982-05-18', 'NREGVN82E18H501W', 'Responsabile Biglietteria', 3);


INSERT IGNORE INTO Posto (fila, numero, tipo, sala) VALUES
(1, 1, 1, 1), (1, 2, 1, 1), (1, 3, 1, 1), (1, 4, 1, 1), (1, 5, 1, 1),
(2, 1, 1, 1), (2, 2, 1, 1), (2, 3, 1, 1), (2, 4, 1, 1), (2, 5, 1, 1),

(3, 1, 2, 1), (3, 2, 2, 1), (3, 3, 2, 1), (3, 4, 2, 1), (3, 5, 2, 1),

(4, 1, 4, 1), (4, 2, 4, 1), (4, 3, 4, 1),

(1, 1, 1, 2), (1, 2, 1, 2), (1, 3, 1, 2), (1, 4, 1, 2),
(2, 1, 1, 2), (2, 2, 1, 2), (2, 3, 1, 2), (2, 4, 1, 2),

(3, 1, 3, 2), (3, 2, 3, 2), (3, 3, 3, 2), (3, 4, 3, 2),

(1, 1, 1, 3), (1, 2, 1, 3), (1, 3, 2, 3), (1, 4, 2, 3),
(2, 1, 3, 3), (2, 2, 3, 3), (2, 3, 4, 3), (2, 4, 4, 3);


INSERT IGNORE INTO Contratto (dataInizio, dataFine, ruoloContrattuale, artista, compagnia) VALUES
('2023-01-01', '2023-12-31', 'Attore Protagonista', 1, 1),
('2023-02-15', '2023-11-30', 'Attrice Protagonista', 2, 1),
('2023-03-01', '2023-10-31', 'Attore Non Protagonista', 3, 2),
('2023-01-15', '2023-12-15', 'Attrice Non Protagonista', 4, 3),
('2023-04-01', '2023-09-30', 'Regista', 5, 4);


INSERT IGNORE INTO Spettacolo (titolo, genere, dataOra, durata, sala, compagnia) VALUES
('Amleto', 'Tragedia', '2023-12-15 20:30:00', '02:30:00', 1, 1),
('La Locandiera', 'Commedia', '2023-12-16 21:00:00', '01:45:00', 2, 2),
('Romeo e Giulietta', 'Tragedia', '2023-12-17 19:00:00', '02:15:00', 1, 3),
('Il Malato Immaginario', 'Commedia', '2023-12-18 20:00:00', '02:00:00', 3, 4),
('La Traviata', 'Opera', '2023-12-20 20:30:00', '03:00:00', 1, 1),
('Sogno di una notte di mezza estate', 'Commedia', '2023-12-22 21:00:00', '02:30:00', 2, 3);


INSERT IGNORE INTO Abbonamento (dataEmissione, dataScadenza, prezzo, tipo, utente) VALUES
('2023-11-01', '2023-12-01', 50.00, 'Mensile', 1),
('2023-07-01', '2024-01-01', 80.00, 'Semestrale', 2),
('2023-01-01', '2024-01-01', 120.00, 'Annuale', 3),
('2023-11-15', '2023-12-15', 50.00, 'Mensile', 4);


INSERT IGNORE INTO Biglietto (prezzo, dataEmissione, utente, spettacolo, posto) VALUES
(30.00, '2023-12-01', 1, 1, 1),  
(20.00, '2023-12-03', 3, 2, 21), 
(30.00, '2023-12-04', 4, 3, 2),  
(60.00, '2023-12-05', 5, 4, 33), 
(18.00, '2023-12-06', 1, 5, 3),  
(27.00, '2023-12-07', 2, 6, 25); 



DELIMITER $$
CREATE PROCEDURE sp_inserisciUtente(
    IN p_nome VARCHAR(30),
    IN p_cognome VARCHAR(30),
    IN p_email VARCHAR(50),
    IN p_telefono VARCHAR(15)
) 
BEGIN 

    IF (SELECT COUNT(*) FROM Utente WHERE email = p_email) = 0 THEN 
        INSERT INTO Utente (nome, cognome, email, telefono)
        VALUES (p_nome, p_cognome, p_email, p_telefono);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email già esistente';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_acquistaBiglietto(
    IN p_idUtente INT(11),
    IN p_idSpettacolo INT(11),
    IN p_idPosto INT(11),
    OUT p_risultato VARCHAR(50)
)
BEGIN
    DECLARE v_postoOccupato INT(11) DEFAULT 0;
    DECLARE v_prezzoBase DECIMAL(10,2);
    DECLARE v_idTipoPosto INT(11);
    DECLARE v_utenteEsiste INT DEFAULT 0;
    DECLARE v_spettacoloEsiste INT DEFAULT 0;
    DECLARE v_postoEsiste INT DEFAULT 0; 

    SELECT COUNT(*) INTO v_utenteEsiste FROM Utente WHERE idUtente = p_idUtente;
    IF v_utenteEsiste = 0 THEN
        SET p_risultato = 'Utente non trovato';
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;

    SELECT COUNT(*) INTO v_spettacoloEsiste FROM Spettacolo WHERE idSpettacolo = p_idSpettacolo;
    IF v_spettacoloEsiste = 0 THEN
        SET p_risultato = 'Spettacolo non trovato';     
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Spettacolo non trovato';
    END IF;

    SELECT COUNT(*) INTO v_postoEsiste FROM Posto WHERE idPosto = p_idPosto;
    IF v_postoEsiste = 0 THEN
        SET p_risultato = 'Posto non trovato'; 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Posto non trovato';
    END IF;

    SELECT tipo INTO v_idTipoPosto FROM Posto WHERE idPosto = p_idPosto;
    SELECT prezzoBase INTO v_prezzoBase FROM TipoPosto WHERE codiceTipo = v_idTipoPosto;

    INSERT INTO Biglietto (prezzo, dataEmissione, utente, spettacolo, posto)
    VALUES (v_prezzoBase, CURDATE(), p_idUtente, p_idSpettacolo, p_idPosto);
    SET p_risultato = 'Biglietto creato con successo';
END $$
DELIMITER ;

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
            SET v_prezzo = 50.00; 
            SET v_durataMesi = 1; 
    END CASE;

    SET v_dataScadenza = DATE_ADD(CURDATE(), INTERVAL v_durataMesi MONTH);

    INSERT INTO Abbonamento (dataEmissione, dataScadenza, prezzo, tipo, utente)
    VALUES (CURDATE(), v_dataScadenza, v_prezzo, p_tipo, p_idUtente);
    
    SET p_risultato = CONCAT('Abbonamento ', p_tipo, ' acquistato con successo. Scadenza: ', v_dataScadenza);
END $$
DELIMITER ;

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

DELIMITER $$
CREATE PROCEDURE sp_visualizzaPostiDisponibili(
    IN p_idSpettacolo INT
)
BEGIN
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
    
    SELECT COUNT(*) INTO v_compagniaEsiste FROM CompagniaTeatrale WHERE idCompagnia = p_idCompagnia;
    IF v_compagniaEsiste = 0 THEN
        SET p_risultato = 'Compagnia teatrale non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Compagnia teatrale non trovata';
    END IF;
    
    SELECT COUNT(*) INTO v_salaEsiste FROM Sala WHERE numeroSala = p_idSala;
    IF v_salaEsiste = 0 THEN
        SET p_risultato = 'Sala non trovata';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sala non trovata';
    END IF;
    
    INSERT INTO Spettacolo (titolo, genere, dataOra, durata, sala, compagnia)
    VALUES (p_titolo, p_genere, p_dataOra, p_durata, p_idSala, p_idCompagnia);
    
    SET p_risultato = CONCAT('Spettacolo "', p_titolo, '" programmato con successo per il ', DATE_FORMAT(p_dataOra, '%d/%m/%Y %H:%i'));
END $$
DELIMITER ;

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

DELIMITER $$
CREATE TRIGGER check_abbonamento
BEFORE INSERT ON Biglietto
FOR EACH ROW
BEGIN
    DECLARE abbonamento_valido INT DEFAULT 0;
    DECLARE sconto DECIMAL(5,2) DEFAULT 0.40;
    
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
        
        (NEW.dataOra BETWEEN dataOra AND ADDTIME(dataOra, durata))
        OR
       
        (fine_spettacolo BETWEEN dataOra AND ADDTIME(dataOra, durata))
        OR
       
        (NEW.dataOra <= dataOra AND fine_spettacolo >= ADDTIME(dataOra, durata))
    );
    
    IF sala_occupata > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala è già occupata in questo orario';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_contaPostiDisponibili(p_idSpettacolo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idSala INT;
    DECLARE v_postiTotali INT;
    DECLARE v_postiOccupati INT;
    DECLARE v_postiDisponibili INT;
    
    
    SELECT sala INTO v_idSala FROM Spettacolo WHERE idSpettacolo = p_idSpettacolo;
    
   
    SELECT capienza INTO v_postiTotali FROM Sala WHERE numeroSala = v_idSala;
    
    
    SELECT COUNT(*) INTO v_postiOccupati FROM Biglietto WHERE spettacolo = p_idSpettacolo;
    
    
    SET v_postiDisponibili = v_postiTotali - v_postiOccupati;
    
    RETURN v_postiDisponibili;
END $$
DELIMITER ;
