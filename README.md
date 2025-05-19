# Gestione Teatro

Sistema di gestione per teatro realizzato con Node.js, Express e MySQL, progettato per la gestione di utenti, spettacoli, biglietti e abbonamenti. L’intero ambiente è containerizzato tramite Docker per facilitare l’installazione e il testing.

## Funzionalità principali

- **Gestione utenti**: creazione, modifica, visualizzazione ed eliminazione utenti
- **Gestione spettacoli**: inserimento, ricerca per data, visualizzazione dettagli e posti disponibili
- **Gestione biglietti**: acquisto, visualizzazione per utente o spettacolo
- **Gestione abbonamenti**: creazione, ricerca per utente, visualizzazione abbonamenti attivi

## Prerequisiti

- [Docker](https://www.docker.com/) installato

## Avvio del progetto

1. Clona la repository:
   ```bash
   git clone https://github.com/elmahuseinovic/gestione-teatro.git
   

2. Accedi alla cartella del progetto:
    ```bash
    cd gestione-teatro
3.  Avvia i container:
    ```bash
    docker-compose up

4. L’applicazione sarà disponibile su http://localhost:3000

## Test delle API
Per testare le API puoi utilizzare Postman . Nella repository è già presente una collezione Postman ( gestioneTeatro.postman_collection.json ):

- Importa la collezione in Postman
- Troverai tutte le richieste già pronte per l’uso
Le API principali disponibili:

- Utenti : creazione, modifica, visualizzazione, eliminazione
- Abbonamenti : creazione, ricerca per utente, abbonamenti attivi
- Spettacoli : visualizzazione, ricerca per data, posti disponibili
- Biglietti : acquisto, visualizzazione per utente o spettacolo

## Struttura del progetto
- app/ - Codice sorgente dell’applicazione Node.js
- app/config/init.sql - Script di inizializzazione del database MySQL (tabelle, dati di esempio, stored procedure, trigger)
- docker-compose.yml - Configurazione dei container Docker
- gestioneTeatro.postman_collection.json - Collezione Postman per testare le API

## Note
- Non è presente un frontend: il progetto si concentra sull’implementazione e la gestione del database e delle API RESTful.
- Tutte le funzionalità possono essere testate tramite Postman o altri client HTTP.