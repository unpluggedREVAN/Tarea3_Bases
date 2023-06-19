CREATE TRIGGER trg_CalcularIntereses
ON CTM
AFTER UPDATE
AS
BEGIN
    UPDATE CTM
    SET saldoIntereses = saldoIntereses + saldoActual * TipoCTM.tasaInteres / 100 / 30
    FROM CTM
    INNER JOIN TipoCTM ON CTM.id_tipo_ctm = TipoCTM.id;
END;
