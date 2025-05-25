DELIMITER $$
CREATE FUNCTION fn_contaPostiDisponibili(in_idSpettacolo INT) 
RETURNS INT
NOT DETERMINISTIC
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

