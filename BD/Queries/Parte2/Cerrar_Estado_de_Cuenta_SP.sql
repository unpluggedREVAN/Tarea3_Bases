-- Procedimiento almacenado para cerrar los estados de cuenta del mes anterior
CREATE PROCEDURE ClosePreviousMonthStatement @idCTM INT
AS
BEGIN

    -- Actualizar el estado de cuenta del mes anterior
    UPDATE EstadodeCuenta
    SET 
        SaldoInteresesCorrientes = 0,
        InteresesMoratorios = (SELECT SUM(InteresesMoratorios) FROM CuentaTarjetaMaestra WHERE idCTM = @idCTM),
        CantidadOperacionesATM = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'ATM' AND idCTM = @idCTM),
        CantidadOperacionesVentanilla = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Ventanilla' AND idCTM = @idCTM),
        SumaPagosAntesFechaPagoMinimo = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Pago' AND FechaTransaccion <= FechaParaPagoMinimo AND idCTM = @idCTM),
        SumaPagosDuranteMes = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Pago' AND idCTM = @idCTM),
        CantidadPagosDuranteMes = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Pago' AND idCTM = @idCTM),
        SumaCompras = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Compra' AND idCTM = @idCTM),
        CantidadCompras = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Compra' AND idCTM = @idCTM),
        SumaRetiros = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Retiro' AND idCTM = @idCTM),
        CantidadRetiros = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento = 'Retiro' AND idCTM = @idCTM),
        SumaTodosCreditos = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento IN ('Pago', 'Credito') AND idCTM = @idCTM),
        CantidadTodosCreditos = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento IN ('Pago', 'Credito') AND idCTM = @idCTM),
        SumaTodosDebitos = (SELECT SUM(Monto) FROM CuentaTarjetaMaestra WHERE TipoMovimiento IN ('Compra', 'Retiro', 'Debito') AND idCTM = @idCTM),
        CantidadTodosDebitos = (SELECT COUNT(*) FROM CuentaTarjetaMaestra WHERE TipoMovimiento IN ('Compra', 'Retiro', 'Debito') AND idCTM = @idCTM)
    WHERE idCTM = @idCTM;
END;
GO