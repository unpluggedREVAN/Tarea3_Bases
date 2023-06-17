CREATE PROCEDURE SP_AbreEstadodeCuenta
    @FechaCorte DATE,
    @IdCuentaMaestra INT
AS
BEGIN
    -- Se declara la variable que almacenará el saldo actual
    DECLARE @SaldoActual DECIMAL(18, 2);
    
    -- Se obtiene el saldo actual de la cuenta
    SELECT @SaldoActual = SaldoActual 
    FROM CuentaTarjetaMaestra
    WHERE IdCuentaMaestra = @IdCuentaMaestra;
    
    -- Se inserta un nuevo estado de cuenta con los valores iniciales
    INSERT INTO EstadodeCuenta
    (
        IdCuentaMaestra,
        FechaCorte,
        SaldoActual,
        SaldoInteresesCorrientes,
        SaldoInteresesMoratorios,
        CantidadOperacionesATM,
        CantidadOperacionesVentanilla,
        SumaPagosAntesFechaPagoMinimoContado,
        SumaPagosDuranteMes,
        CantidadPagosDuranteMes,
        SumaCompras,
        CantidadCompras,
        SumaRetiros,
        CantidadRetiros,
        SumaTodosCreditos,
        CantidadTodosCreditos,
        SumaTodosDebitos,
        CantidadTodosDebitos
    )
    VALUES
    (
        @IdCuentaMaestra,
        @FechaCorte,
        @SaldoActual,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
    );
    
    -- Se actualizan los saldos de la cuenta maestra a cero
    UPDATE CuentaTarjetaMaestra
    SET 
        SaldoInteresesCorrientes = 0,
        SaldoInteresesMoratorios = 0
    WHERE IdCuentaMaestra = @IdCuentaMaestra;
    
END;
GO
