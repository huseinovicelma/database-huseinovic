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

CREATE OR REPLACE VIEW v_abbonamenti AS
    SELECT a.*, u.nome, u.cognome
    FROM Abbonamento a
    JOIN Utente u ON a.utente = u.idUtente
    ORDER BY a.dataScadenza DESC;

CREATE OR REPLACE VIEW v_abbonamenti_attivi AS
    SELECT a.*, u.nome, u.cognome
    FROM Abbonamento a
    JOIN Utente u ON a.utente = u.idUtente
    WHERE CURDATE() BETWEEN a.dataEmissione AND a.dataScadenza
    ORDER BY a.dataScadenza;

CREATE OR REPLACE VIEW v_biglietti AS
    SELECT b.*, u.nome, u.cognome, s.titolo, s.dataOra, p.fila, p.numero
    FROM Biglietto b
    JOIN Utente u ON b.utente = u.idUtente
    JOIN Spettacolo s ON b.spettacolo = s.idSpettacolo
    JOIN Posto p ON b.posto = p.idPosto
    ORDER BY b.dataEmissione DESC;

CREATE OR REPLACE VIEW v_spettacoli AS
    SELECT s.*, sa.nome AS nomeSala, ct.nome AS nomeCompagnia 
    FROM Spettacolo s
    JOIN Sala sa ON s.sala = sa.numeroSala
    JOIN CompagniaTeatrale ct ON s.compagnia = ct.idCompagnia
    ORDER BY s.dataOra;

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

DELIMITER $$
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
    IN in_idUtente INT,
    OUT risultato VARCHAR(100)
)
BEGIN
    DECLARE contaBiglietti INT DEFAULT 0;
    DECLARE contaAbbonamenti INT DEFAULT 0;
    
    -- Verifica se l'utente esiste
    IF NOT EXISTS (SELECT 1 FROM Utente WHERE idUtente = in_idUtente) THEN
        SET risultato = 'Utente non trovato';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non trovato';
    END IF;
    
    -- Conta i biglietti associati all'utente
    SELECT COUNT(*) INTO contaBiglietti FROM Biglietto WHERE utente = in_idUtente;
    
    -- Conta gli abbonamenti associati all'utente
    SELECT COUNT(*) INTO contaAbbonamenti FROM Abbonamento WHERE utente = in_idUtente;
    
    -- Elimina i biglietti associati all'utente
    DELETE FROM Biglietto WHERE utente = in_idUtente;
    
    -- Elimina gli abbonamenti associati all'utente
    DELETE FROM Abbonamento WHERE utente = in_idUtente;
    
    -- Elimina l'utente
    DELETE FROM Utente WHERE idUtente = in_idUtente;
    
    SET risultato = CONCAT('Utente eliminato con successo. Eliminati anche ', 
                            contaBiglietti, ' biglietti e ', 
                            contaAbbonamenti, ' abbonamenti associati.');
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
CREATE FUNCTION fn_contaPostiDisponibili(in_idSpettacolo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE idSala INT;
    DECLARE postiTotali INT;
    DECLARE postiOccupati INT;
    DECLARE postiDisponibili INT;
    
    
    SELECT sala INTO idSala FROM Spettacolo WHERE idSpettacolo = in_idSpettacolo;
    
   
    SELECT capienza INTO postiTotali FROM Sala WHERE numeroSala = idSala;
    
    
    SELECT COUNT(*) INTO postiOccupati FROM Biglietto WHERE spettacolo = in_idSpettacolo;
    
    
    SET postiDisponibili = postiTotali - postiOccupati;
    
    RETURN postiDisponibili;
END $$
DELIMITER ;
