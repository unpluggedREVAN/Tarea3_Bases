-- Procedimiento almacenado para abrir los estados de cuenta del nuevo mes
CREATE PROCEDURE OpenNewMonthStatement @idCTM INT
AS
BEGIN
    -- Insertar un nuevo estado de cuenta para el nuevo mes
    INSERT INTO EstadodeCuenta
    (
        idCTM,
        SaldoActual,
        PagoMinimoMesAnterior,
        FechaParaPagoMinimo,
        InteresesCorrientesAcumulados,
        InteresesMoratorios,
        CantidadOperacionesATM,
        CantidadOperacionesVentanilla,
        SumaPagosAntesFechaPagoMinimo,
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
    SELECT
        @idCTM, -- idCTM
        0, -- Saldo actual
        (SELECT PagoMinimo FROM EstadodeCuenta WHERE idCTM = @idCTM ORDER BY FechaCorte DESC LIMIT 1), -- Pago mínimo del mes anterior
        DATEADD(MONTH, 1, (SELECT FechaParaPagoMinimo FROM EstadodeCuenta WHERE idCTM = @idCTM ORDER BY FechaCorte DESC LIMIT 1)), -- Fecha para pago mínimo es la fecha actual más un mes
        0, -- Intereses corrientes acumulados
        0, -- Intereses moratorios
        0, -- Cantidad de operaciones en ATM
        0, -- Cantidad de operaciones en Ventanilla
        0, -- Suma de pagos antes de la fecha de pago mínimo
        0, -- Suma de pagos durante el mes
        0, -- Cantidad de pagos durante el mes
        0, -- Suma de compras
        0, -- Cantidad de compras
        0, -- Suma de retiros
        0, -- Cantidad de retiros
        0, -- Suma de todos los créditos
        0, -- Cantidad de todos los créditos
        0, -- Suma de todos los débitos
        0  -- Cantidad de todos los débitos
    FROM EstadodeCuenta
    WHERE idCTM = @idCTM;
END;
GO
