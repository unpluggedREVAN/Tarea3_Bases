CREATE PROCEDURE SP_AbreSubEstadodeCuenta
    @FechaApertura DATETIME,
    @IdCuentaTarjetaAsociada INT
AS
BEGIN
    DECLARE @SaldoActual DECIMAL(18,2);
    DECLARE @InteresesCorrientes DECIMAL(18,2);
    DECLARE @InteresesMoratorios DECIMAL(18,2);
    DECLARE @CargosPorServicio DECIMAL(18,2);
    DECLARE @CargosPorMulta DECIMAL(18,2);
    DECLARE @CargosPorSeguro DECIMAL(18,2);

    -- Inicializa los valores para la apertura
    SET @SaldoActual = 0;
    SET @InteresesCorrientes = 0;
    SET @InteresesMoratorios = 0;
    SET @CargosPorServicio = 0;
    SET @CargosPorMulta = 0;
    SET @CargosPorSeguro = 0;

    -- Inserta una nueva fila para el nuevo sub-estado de cuenta
    INSERT INTO SubEstadodeCuenta
    (
        IdCuentaTarjetaAsociada,
        FechaApertura,
        SaldoActual,
        InteresesCorrientes,
        InteresesMoratorios,
        CargosPorServicio,
        CargosPorMulta,
        CargosPorSeguro
    )
    VALUES
    (
        @IdCuentaTarjetaAsociada,
        @FechaApertura,
        @SaldoActual,
        @InteresesCorrientes,
        @InteresesMoratorios,
        @CargosPorServicio,
        @CargosPorMulta,
        @CargosPorSeguro
    );

    -- Inicializa los valores de los movimientos para el nuevo ciclo
    UPDATE Movimientos SET
        CantidadOperacionesATM = 0,
        CantidadOperacionesVentanilla = 0,
        SumaCompras = 0,
        CantidadCompras = 0,
        SumaRetiros = 0,
        CantidadRetiros = 0,
        SumaCreditos = 0,
        SumaDebitos = 0
    WHERE IdCuentaTarjetaAsociada = @IdCuentaTarjetaAsociada;

END;
