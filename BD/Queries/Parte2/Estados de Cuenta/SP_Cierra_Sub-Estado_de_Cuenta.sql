CREATE PROCEDURE SP_CierraSubEstadodeCuenta
    @FechaCierre DATE,
    @IdCuentaTarjetaAsociada INT
AS
BEGIN
    -- Declara las variables necesarias
    DECLARE @SaldoActual DECIMAL(18,2);
    DECLARE @InteresesCorrientes DECIMAL(18,2);
    DECLARE @InteresesMoratorios DECIMAL(18,2);
    DECLARE @CargosPorServicio DECIMAL(18,2);
    DECLARE @CargosPorMulta DECIMAL(18,2);
    DECLARE @CargosPorSeguro DECIMAL(18,2);

    -- Obtiene los valores actuales del Sub-EC
    SELECT 
        @SaldoActual = SaldoActual,
        @InteresesCorrientes = InteresesCorrientes,
        @InteresesMoratorios = InteresesMoratorios,
        @CargosPorServicio = CargosPorServicio,
        @CargosPorMulta = CargosPorMulta,
        @CargosPorSeguro = CargosPorSeguro
    FROM 
        SubEstadodeCuenta
    WHERE 
        FechaCierre = @FechaCierre AND IdCuentaTarjetaAsociada = @IdCuentaTarjetaAsociada;

    -- Esquema tentativo
    -- Calcula y aplica los nuevos valores para el cierre
    SET @SaldoActual = @SaldoActual + @InteresesCorrientes + @InteresesMoratorios + @CargosPorServicio + @CargosPorMulta + @CargosPorSeguro;
    
    -- Asegúrate de que los movimientos de crédito y débito se generen y registren en las tablas correspondientes
    INSERT INTO Movimientos (IdCuentaTarjetaAsociada, TipoMovimiento, Monto, FechaMovimiento)
    VALUES (@IdCuentaTarjetaAsociada, 'Intereses Corrientes', @InteresesCorrientes, @FechaCierre),
           (@IdCuentaTarjetaAsociada, 'Intereses Moratorios', @InteresesMoratorios, @FechaCierre),
           (@IdCuentaTarjetaAsociada, 'Cargos por Servicio', @CargosPorServicio, @FechaCierre),
           (@IdCuentaTarjetaAsociada, 'Cargos por Multa', @CargosPorMulta, @FechaCierre),
           (@IdCuentaTarjetaAsociada, 'Cargos por Seguro', @CargosPorSeguro, @FechaCierre);
    
    -- Redime los intereses
    DECLARE @TotalIntereses DECIMAL(18,2);
    SET @TotalIntereses = @InteresesCorrientes + @InteresesMoratorios;
    
    -- Genera un crédito igual a los intereses acumulados
    INSERT INTO Movimientos (IdCuentaTarjetaAsociada, TipoMovimiento, Monto, FechaMovimiento)
    VALUES (@IdCuentaTarjetaAsociada, 'Redención de Intereses', -@TotalIntereses, @FechaCierre);
    
    -- Resta los intereses redimidos del saldo actual
    SET @SaldoActual = @SaldoActual - @TotalIntereses;

    -- Actualiza el Sub-EC
    UPDATE 
        SubEstadodeCuenta
    SET
        SaldoActual = @SaldoActual,
        InteresesCorrientes = 0,
        InteresesMoratorios = 0,
        CargosPorServicio = 0,
        CargosPorMulta = 0,
        CargosPorSeguro = 0
    WHERE 
        FechaCierre = @FechaCierre AND IdCuentaTarjetaAsociada = @IdCuentaTarjetaAsociada;
    
    -- Reestablecer a cero los campos restantes
    UPDATE
        CuentaTarjetaAsociada
    SET
        CantidadOperacionesATM = 0,
        CantidadOperacionesVentanilla = 0,
        SumaCompras = 0,
        CantidadCompras = 0,
        SumaRetiros = 0,
        CantidadRetiros = 0,
        SumaTodosCreditos = 0,
        SumaTodosDebitos = 0
    WHERE
        Id = @IdCuentaTarjetaAsociada;
    
END
