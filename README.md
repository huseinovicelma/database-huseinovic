# Gestione Teatro

Sistema di gestione per teatro realizzato con Node.js, Express e MySQL, progettato per la gestione di utenti, spettacoli, biglietti e abbonamenti. L’intero ambiente è containerizzato tramite Docker per facilitare l’installazione e il testing.

## Funzionalità principali

- **Gestione utenti**: creazione, modifica, visualizzazione ed eliminazione utenti
- **Gestione spettacoli**: inserimento, ricerca per data, visualizzazione dettagli e posti disponibili
- **Gestione biglietti**: acquisto, visualizzazione per utente o spettacolo
- **Gestione abbonamenti**: creazione, ricerca per utente, visualizzazione abbonamenti attivi

## Prerequisiti

- [Docker](https://www.docker.com/) e [Docker Compose](https://docs.docker.com/compose/) installati

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