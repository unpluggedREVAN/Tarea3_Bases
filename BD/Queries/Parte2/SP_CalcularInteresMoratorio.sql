CREATE PROCEDURE CalcularInteresMoratorio
	@fechaItera DATE,
AS
BEGIN
    -- Declara variables
    DECLARE @TasaInteresMoratorios FLOAT

    -- Obtiene la tasa de interés moratorios
    SELECT @TasaInteresMoratorios = TasaInteresMoratorios
    FROM TipoMovInteresMoratorio
    WHERE Nombre = 'Debito Interes Saldo'

    -- Calcula el monto de débito de intereses moratorios y actualiza el interés acumulado moratorio para todas las cuentas con saldo mayor a cero
    UPDATE CuentaTarjetaMaestra
    SET InteresAcumuladoMoratorio = InteresAcumuladoMoratorio 
        + ((MontoPagoMinimo - ISNULL((
                        SELECT SUM(Monto) 
                        FROM Pagos 
                        WHERE FechaPago > FechaParaPagoMinimoDeContado 
                        AND IdCuentaTarjeta = CuentaTarjetaCredito.Id
                    ), 0)) 
            / @TasaInteresMoratorios / 100 / 30)
    FROM CuentaTarjetaMaestra
    INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaMaestra.IdCuentaTarjeta = CuentaTarjetaCredito.Id
    WHERE CuentaTarjetaCredito.SaldoActual > 0 AND CuentaTarjetaCredito.FechaOperacion > CuentaTarjetaCredito.FechaParaPagoMinimoDeContado

    -- Registra el movimiento de interés moratorio para todas las cuentas con saldo mayor a cero
    INSERT INTO MovimientoInteresMoratorio (Fecha, Monto, NuevoInteresAcumuladoMoratorio, IdCuentaTarjetaMaestra, IdTipoMovimiento)
    SELECT 
        @fechaItera, (MontoPagoMinimo - ISNULL((
                    SELECT SUM(Monto) 
                    FROM Pagos 
                    WHERE FechaPago > FechaParaPagoMinimoDeContado 
                    AND IdCuentaTarjeta = CuentaTarjetaCredito.Id
                ), 0)) / @TasaInteresMoratorios / 100 / 30, 
        InteresAcumuladoMoratorio, 
        Id, 
        1 -- Asume que el IdTipoMovimiento para 'Debito Interes Saldo' es 1
    FROM CuentaTarjetaMaestra
    INNER JOIN CuentaTarjetaCredito ON CuentaTarjetaMaestra.IdCuentaTarjeta = CuentaTarjetaCredito.Id
    WHERE CuentaTarjetaCredito.SaldoActual > 0 AND CuentaTarjetaCredito.FechaOperacion > CuentaTarjetaCredito.FechaParaPagoMinimoDeContado
END
GO
