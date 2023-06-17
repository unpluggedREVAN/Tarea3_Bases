CREATE PROCEDURE SP_CierraEstadodeCuenta 
	@IdCuentaMaestra INT
	, @FechaCierre DATE
AS
BEGIN
    -- Declaramos las variables
    DECLARE @SaldoActual DECIMAL(18, 2), @SaldoInteresesCorrientes DECIMAL(18, 2), @SaldoInteresesMoratorios DECIMAL(18, 2);
    
    -- Obtenemos los valores actuales
    SELECT @SaldoActual = SaldoActual, @SaldoInteresesCorrientes = SaldoInteresesCorrientes, @SaldoInteresesMoratorios = SaldoInteresesMoratorios
    FROM EstadodeCuenta
    WHERE IdCuentaMaestra = @IdCuentaMaestra AND FechaDeCorte < @FechaCierre;
    
    -- Agregamos los intereses al saldo actual
    SET @SaldoActual = @SaldoActual + @SaldoInteresesCorrientes + @SaldoInteresesMoratorios;
    
    -- Actualizamos el saldo actual y restablecemos los intereses
    UPDATE EstadodeCuenta
    SET SaldoActual = @SaldoActual, SaldoInteresesCorrientes = 0, SaldoInteresesMoratorios = 0
    WHERE IdCuentaMaestra = @IdCuentaMaestra AND FechaDeCorte < @FechaCierre;
    
    -- Generar los movimientos de débito y demás operaciones aquí
    -- INSERT INTO Movements(...) VALUES(...)

	-- Esquema no terminado
	INSERT INTO Movimientos(IdCuentaMaestra, TipoMovimiento, Monto, FechaMovimiento)
	VALUES
		(@IdCuentaMaestra, 'Intereses Corrientes', @SaldoInteresesCorrientes, @FechaCierre),
		(@IdCuentaMaestra, 'Intereses Moratorios', @SaldoInteresesMoratorios, @FechaCierre);

    -- Restablecer a cero los campos restantes en la tabla CuentaTarjetaMaestra
    UPDATE CuentaTarjetaMaestra
    SET 
        CantidadOperacionesATM = 0,
        CantidadOperacionesVentanilla = 0,
        SumaPagosAntesFechaPago = 0,
        SumaPagosDuranteMes = 0,
        CantidadPagosDuranteMes = 0,
        SumaCompras = 0,
        CantidadCompras = 0,
        SumaRetiros = 0,
        CantidadRetiros = 0,
        SumaCreditos = 0,
        CantidadCreditos = 0,
        SumaDebitos = 0,
        CantidadDebitos = 0
    WHERE IdCuentaMaestra = @IdCuentaMaestra;
    
END;
