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

CREATE TABLE IF NOT EXISTS Posto (
    idPosto INT(11) NOT NULL AUTO_INCREMENT,
    fila INT(11) NOT NULL,
    numero INT(11) NOT NULL,
    tipo INT(11) NOT NULL,
    sala INT(11) NOT NULL,
    PRIMARY KEY (idPosto),
    FOREIGN KEY (Sala) REFERENCES Sala(numeroSala),
    FOREIGN KEY (codiceTipo) REFERENCES TipoPosto(codiceTipo)
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