DELIMITER $$
CREATE FUNCTION fn_contaPostiDisponibili(p_idSpettacolo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idSala INT;
    DECLARE v_postiTotali INT;
    DECLARE v_postiOccupati INT;
    DECLARE v_postiDisponibili INT;
    
    -- Ottieni la sala dello spettacolo
    SELECT sala INTO v_idSala FROM Spettacolo WHERE idSpettacolo = p_idSpettacolo;
    
    -- Conta i posti totali nella sala
    SELECT capienza INTO v_postiTotali FROM Sala WHERE numeroSala = v_idSala;
    
    -- Conta i posti già occupati
    SELECT COUNT(*) INTO v_postiOccupati FROM Biglietto WHERE spettacolo = p_idSpettacolo;
    
    -- Calcola i posti disponibili
    SET v_postiDisponibili = v_postiTotali - v_postiOccupati;
    
    RETURN v_postiDisponibili;
END $$
DELIMITER ;

