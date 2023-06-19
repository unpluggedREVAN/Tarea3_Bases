CREATE VIEW Vista_Tarjetas_Disponibles AS
SELECT Id, NumeroTarjetaFisica
FROM dbo.NuevaTarjetaFisica
WHERE Usado = 0;
