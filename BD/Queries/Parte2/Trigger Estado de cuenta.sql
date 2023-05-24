CREATE TRIGGER tr_EstadodeCuenta
ON dbo.CuentaTarjetaMaestra
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FechaItera datetime;
    SET @FechaItera = GETDATE(); -- Hay que cambiar por fechaItera real

    -- Cerrar estados de cuenta del mes anterior
    UPDATE 
        dbo.EstadodeCuenta
    SET 
        FechaCorte = @FechaItera
    FROM 
        inserted i
    WHERE 
        dbo.EstadodeCuenta.IdCuentaTarjetaMaestra = i.Id
        AND MONTH(dbo.EstadodeCuenta.Fecha) = MONTH(@FechaItera) - 1
        AND YEAR(dbo.EstadodeCuenta.Fecha) = YEAR(@FechaItera);

    -- Abrir nuevos estados de cuenta para el nuevo mes
    INSERT INTO dbo.EstadodeCuenta (Fecha, Saldo, IdCuentaTarjetaMaestra)
    SELECT 
        @FechaItera, -- Fecha de corte
        0, -- Saldo inicial
        i.Id -- Id de la nueva CuentaTarjetaMaestra
    FROM 
        inserted i
    WHERE 
        DAY(i.FechaCreacion) = DAY(@FechaItera); -- Asume que la fecha de corte es el día de la fecha de creación de la CTM

    -- Declarar tabla variable
    DECLARE @TempTable TABLE (
        PagoMinimoMesAnterior money,
        FechaParaPagoMinimoDeContado datetime,
        InteresesCorrientesAcumulados money,
        InteresesMoratorios money,
        CantidadOperacionesATM int,
        CantidadOperacionesVentanilla int,
        SumaPagosAntesFechaParaPagoMinimoDeContado money,
        SumaPagosDuranteMes money,
        CantidadPagosDuranteMes int,
        SumaCompras money,
        CantidadCompras int,
        SumaRetiros money,
        CantidadRetiros int,
        SumaTodosCreditos money,
        CantidadTodosCreditos int,
        SumaTodosDebitos money,
        CantidadTodosDebitos int
    );

    -- Insertar datos de la CuentaTarjetaMaestra en la tabla variable
    INSERT INTO @TempTable
    SELECT 
        PagoMinimoMesAnterior,
        FechaParaPagoMinimoDeContado,
        InteresesCorrientesAcumulados,
        InteresesMoratorios,
        CantidadOperacionesATM,
        CantidadOperacionesVentanilla,
        SumaPagosAntesFechaParaPagoMinimoDeContado,
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
    FROM 
        inserted;

    -- Insertar datos de la tabla variable en la tabla EstadoCuenta
    INSERT INTO dbo.EstadodeCuenta
    SELECT *
    FROM @TempTable;
END;
GO
