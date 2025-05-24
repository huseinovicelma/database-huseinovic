CREATE DATABASE IF NOT EXISTS GestioneTeatro;

USE GestioneTeatro;

CREATE TABLE IF NOT EXISTS Utente (
    idUtente INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    cognome VARCHAR(30) NOT NULL,
    email VARCHAR(50) UNIQUE,
    telefono VARCHAR(15),
    PRIMARY KEY (idUtente)
);

CREATE TABLE IF NOT EXISTS Abbonamento (
    codiceAbbonamento INT(11) NOT NULL AUTO_INCREMENT,
    dataEmissione DATE NOT NULL,
    dataScadenza DATE NOT NULL,   
    prezzo DECIMAL(10,2) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    utente INT(11) NOT NULL,
    PRIMARY KEY (codiceAbbonamento),
    FOREIGN KEY (utente) REFERENCES Utente(idUtente) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Biglietto (
    codiceBiglietto INT(11) NOT NULL AUTO_INCREMENT,
    prezzo DECIMAL(10,2) NOT NULL,
    dataEmissione DATE NOT NULL,
    utente INT(11) NOT NULL,
    spettacolo INT(11) NOT NULL,
    posto INT(11) NOT NULL,
    PRIMARY KEY (codiceBiglietto),
    FOREIGN KEY (utente) REFERENCES Utente(idUtente) ON DELETE CASCADE,
    FOREIGN KEY (spettacolo) REFERENCES Spettacolo(idSpettacolo),
    FOREIGN KEY (posto) REFERENCES Posto(idPosto)
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

CREATE TABLE IF NOT EXISTS CompagniaTeatrale (
    idCompagnia INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    annoFondazione YEAR NOT NULL,
    PRIMARY KEY (idCompagnia)   
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

CREATE TABLE IF NOT EXISTS Artista (
    idArtista INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    cognome VARCHAR(30) NOT NULL,
    dataNascita DATE NOT NULL,
    CF VARCHAR(16) NOT NULL,
    PRIMARY KEY (idArtista) 
);

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