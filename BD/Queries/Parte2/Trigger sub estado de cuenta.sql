CREATE TRIGGER trg_SubEstadodeCuenta
ON CuentaTarjetaAdicional
AFTER INSERT
AS
BEGIN
    -- Declarar variables
    DECLARE @IdCuentaTarjetaAdicional INT;
    DECLARE @IdEstadodeCuenta INT;
    DECLARE @FechaItera DATE = GETDATE(); -- Cambiar por @fechaItera verdadero

    -- Obtener el IdCuentaTarjetaAdicional de la fila insertada
    SELECT @IdCuentaTarjetaAdicional = Id FROM inserted;

    -- Obtener el IdEstadodeCuenta para el nuevo SubEstadodeCuenta
    -- Para este ejemplo, lo estoy estableciendo a 1
    SET @IdEstadodeCuenta = 1; -- Pero se cambia por IdEstadodeCuenta verdadero

    -- Cerrar el estado de cuenta del mes anterior
    UPDATE SubEstadodeCuenta
    SET FechaCorte = @FechaItera
    WHERE IdCuentaTarjetaAdicional = @IdCuentaTarjetaAdicional
    AND MONTH(FechaCorte) = MONTH(@FechaItera) - 1
    AND YEAR(FechaCorte) = YEAR(@FechaItera);

    -- Abrir un nuevo estado de cuenta para el nuevo mes
    INSERT INTO SubEstadodeCuenta
    (
        IdEstadodeCuenta,
        IdCuentaTarjetaAdicional,
        CantidadOperacionesATM,
        CantidadOperacionesVentanilla,
        SumaCompras,
        CantidadCompras,
        SumaRetiros,
        CantidadRetiros,
        SumaCreditos,
        SumaDebitos,
        FechaPagoMinimo,
        MontoPagoMinimo,
        PagoContado,
        InteresesCorrientes,
        InteresesMoratorios,
        FechaCorte
    )
    VALUES
    (
        @IdEstadodeCuenta,
        @IdCuentaTarjetaAdicional,
        0, -- CantidadOperacionesATM
        0, -- CantidadOperacionesVentanilla
        0, -- SumaCompras
        0, -- CantidadCompras
        0, -- SumaRetiros
        0, -- CantidadRetiros
        0, -- SumaCreditos
        0, -- SumaDebitos
        DATEADD(DAY, 10, @FechaItera), -- FechaPagoMinimo
        0, -- MontoPagoMinimo
        0, -- PagoContado
        0, -- InteresesCorrientes
        0,  -- InteresesMoratorios
        @FechaItera -- FechaCorte
    );
END;
GO