CREATE PROCEDURE SP_CalcularInteresCorriente
	@fechaItera, DATE
AS
BEGIN
    -- Declara variables
    DECLARE @TasaInteresCorriente FLOAT

    -- Obtiene la tasa de interés corriente
    SELECT @TasaInteresCorriente = TasaInteresCorriente
    FROM TipoMovInteresCorriente
    WHERE Nombre = 'Debito Interes Saldo'

    -- Calcula el monto de débito de intereses corrientes y actualiza el interés acumulado corriente para todas las cuentas con saldo mayor a cero
    UPDATE CuentaTarjetaMaestra
    SET InteresAcumuladoCorriente = InteresAcumuladoCorriente + (SaldoActual / @TasaInteresCorriente / 100 / 30)
    FROM CuentaTarjetaMaestra
    INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaMaestra.IdCuentaTarjeta = CuentaTarjetaCredito.Id
    WHERE CuentaTarjetaCredito.SaldoActual > 0

    -- Registra el movimiento de interés corriente para todas las cuentas con saldo mayor a cero
    INSERT INTO MovimientoInteresCorriente (Fecha, Monto, NuevoInteresAcumuladoCorriente, IdCuentaTarjetaMaestra, IdTipoMovimiento)
    SELECT @fechaItera, SaldoActual / @TasaInteresCorriente / 100 / 30, InteresAcumuladoCorriente, Id, 1 -- Asume que el IdTipoMovimiento para 'Debito Interes Saldo' es 1
    FROM CuentaTarjetaMaestra
    INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaMaestra.IdCuentaTarjeta = CuentaTarjetaCredito.Id
    WHERE CuentaTarjetaCredito.SaldoActual > 0
END
GO
