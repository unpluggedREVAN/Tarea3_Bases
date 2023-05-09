CREATE PROCEDURE dbo.SP_ImportarOperacionesXML
    @inRutaXML NVARCHAR(255),
    @outResultCode INT OUTPUT
AS 
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY 
        SET @outResultCode = 0;
        DECLARE @XmlData XML;
		SELECT @XmlData = BulkColumn
		FROM OPENROWSET(BULK 'C:\Users\Usuario\Desktop\DB\Queries\XMLBD2_Operaciones.xml', SINGLE_BLOB) AS x

        DECLARE @Fechas TABLE (Fecha DATE);
        DECLARE @FechaItera DATE, @FechaFinal DATE;

        -- Tablas temporales para cada nodo del XML

		DECLARE @NuevosTH TABLE(
			Nombre VARCHAR(256)
			, Tipo_Doc_Identidad VARCHAR(256) 
			, Valor_Doc_Identidad VARCHAR(256)
			, NombreUsuario VARCHAR(256)
			, Password VARCHAR(256) 
		);

		DECLARE @NuevosTCM TABLE(
			Codigo VARCHAR(1024)
			, TipoCTM VARCHAR(50)
			, LimiteCredito VARCHAR(50) 
			, TH VARCHAR(256) 
		);

		DECLARE @NuevosTCA TABLE(
			CodigoTCM VARCHAR(1024)
			, CodigoTCA VARCHAR(50)
			, TH VARCHAR(50) --
		);

		DECLARE @NuevosTF TABLE(
			Codigo VARCHAR(1024)
			, TCAsociada VARCHAR(50)
			, FechaVencimiento VARCHAR(50)
			, CCV VARCHAR(256)
		);

		DECLARE @NuevosMovimientos TABLE(
			Nombre VARCHAR(1024)
			, TF VARCHAR(50) 
			, FechaMovimiento VARCHAR(50) 
			, Monto VARCHAR(256) 
			, Descripcion VARCHAR(50)
			, Referencia VARCHAR(50) 
		);

        -- Extraer todas las fechas del XML y almacenarlas en @Fechas
        INSERT INTO @Fechas (Fecha)
        SELECT T.c.value('@Fecha', 'DATE') AS Fecha
        FROM @XmlData.nodes('/root/fechaOperacion') AS T(c);

        SELECT @FechaItera = MIN(F.Fecha)
				, @FechaFinal = MAX(F.Fecha)
        FROM @Fechas F;

		BEGIN TRANSACTION tImportarOperacionesXML

        WHILE (@FechaItera <= @FechaFinal)
        BEGIN

			IF EXISTS (SELECT 1 FROM @Fechas WHERE Fecha = @FechaItera)
				BEGIN
					-- Extraer del XML los nuevos TH e insertarlos en @NuevosTH
					INSERT INTO @NuevosTH (Nombre, Tipo_Doc_Identidad, Valor_Doc_Identidad, NombreUsuario, Password)
					SELECT 
							T.th.value('@Nombre', 'NVARCHAR(256)') AS Nombre
							, T.th.value('@Tipo_Doc_Identidad', 'NVARCHAR(256)') AS Tipo_Doc_Identidad
							, T.th.value('@Valor_Doc_Identidad', 'NVARCHAR(256)') AS Valor_Doc_Identidad
							, T.th.value('@NombreUsuario', 'NVARCHAR(256)') AS NombreUsuario
							, T.th.value('@Password', 'NVARCHAR(256)') AS Password
					FROM @XmlData.nodes('/root/fechaOperacion/TH/TH') AS T(th)
					--WHERE T.th.value('@Fecha', 'DATE') = @FechaItera;

					-- Repite este patrón para NTCM, NTCA, NTF y Movimiento
					INSERT INTO @NuevosTCM (Codigo, TipoCTM, LimiteCredito, TH)
					SELECT 
							T.tcm.value('@Codigo', 'NVARCHAR(64)') AS Codigo
							, T.tcm.value('@TipoCTM', 'NVARCHAR(64)') AS TipoCTM
							, T.tcm.value('@LimiteCredito', 'NVARCHAR(64)') AS LimiteCredito
							, T.tcm.value('@TH', 'NVARCHAR(64)') AS TH
					FROM @XmlData.nodes('/root/fechaOperacion/NTCM/NTCM') AS T(tcm)
					--WHERE T.tcm.value('@Fecha', 'DATE') = @FechaItera;

					INSERT INTO @NuevosTCA (Nombre, CodigoTCM, CodigoTCA, TH)
					SELECT 
							T.tca.value('@Nombre', 'NVARCHAR(64)') AS Nombre
							, T.tca.value('@CodigoTCM', 'NVARCHAR(64)') AS CodigoTCM
							, T.tca.value('@CodigoTCA', 'NVARCHAR(64)') AS CodigoTCA
							, T.tca.value('@TH', 'NVARCHAR(64)') AS TH
					FROM @XmlData.nodes('/root/fechaOperacion/NTCA/NTCA') AS T(tca)
					--WHERE T.tca.value('(Fecha/text())[1]', 'DATE') = @FechaItera;

					INSERT INTO @NuevosTF (Nombre, Codigo, TCAsociada, FechaVencimiento, CCV)
					SELECT 
							T.tf.value('@Nombre', 'NVARCHAR(64)') AS Nombre
							, T.tf.value('@Codigo', 'NVARCHAR(64)') AS Codigo
							, T.tf.value('@TCAsociada', 'NVARCHAR(64)') AS TCAsociada
							, T.tf.value('@FechaVencimiento', 'NVARCHAR(64)') AS FechaVencimiento
							, T.tf.value('@CCV', 'NVARCHAR(64)') AS CCV
					FROM @XmlData.nodes('/root/fechaOperacion/NTF/NTF') AS T(tf)
					--WHERE T.tf.value('(Fecha/text())[1]', 'DATE') = @FechaItera;

					INSERT INTO @NuevosMovimientos (Nombre, TF, FechaMovimiento, Monto, Descripcion, Referencia)
					SELECT 
							T.m.value('Nombre', 'NVARCHAR(64)') AS Nombre
							, T.m.value('@TF', 'NVARCHAR(64)') AS TF
							, T.m.value('@FechaMovimiento', 'NVARCHAR(64)') AS FechaMovimiento
							, T.m.value('@Monto', 'NVARCHAR(64)') AS Monto
							, T.m.value('@Descripcion', 'NVARCHAR(64)') AS Descripcion
							, T.m.value('@Referencia', 'NVARCHAR(64)') AS Referencia
					FROM @XmlData.nodes('/root/fechaOperacion/Movimiento/Movimiento') AS T(m)
					--WHERE T.m.value('(Fecha/text())[1]', 'DATE') = @FechaItera;

					-- Insertar en la tabla TarjetaHabiente lo contenido en @NuevosTH
					-- y mapearlo con inner join para obtener los Id
					INSERT INTO dbo.TarjetaHabiente(Nombre, IdTipoDocumentoID, ValorDocumentoID, Password)
					SELECT ...
					FROM @NuevosTH th;

					-- Insertar en las tablas de la base de datos correspondientes: NTCM, NTCA, NTF y Movimiento
					INSERT INTO dbo.CuentaTarjetaMaestra(IdTarjetaHabiente, IdCuentaTarjeta, InteresAcumuladoCorriente, InteresAcumuladoMoratorio)
					SELECT ...
					FROM @NuevosNTCM tcm;

					INSERT INTO dbo.CuentaTarjetaAdicional(IdCuentaMaestra, IdTarjetaHabiente, IdCuentaTarjeta)
					SELECT ...
					FROM @NuevosNTCA tca;

					INSERT INTO dbo.TarjetaFisica(Codigo, CVV, Pin, FechaEmision, FechaInvalidacion, AñoVencimiento, MesVencimiento, IdCuentaTarjeta, IdMotivoInvalidacion)
					SELECT ...
					FROM @NuevosNTF tf;

					INSERT INTO dbo.Movimiento(Descripcion, Monto, NuevoSaldo, Fecha, Referencia, IdTipoMovimiento, IdEstadoCuenta, IdTarjetaFisica)
					SELECT ...
					FROM @NuevosMovimientos m;

				END -- Fin del IF

			--Iniciar proceso diario para cada TCM:
				--Procesar movimientos
				--Procesar vencimientos de TF
				--Calcular intereses
				--SI TCM tiene corte en @FechaItera
					--Cerrar EC del TCM
					--Abrir EC del TCM
				--Fin SI

			-- Actualizar @FechaItera para el próximo ciclo
			SET @FechaItera = DATEADD(day, 1, @FechaItera);

		END -- Fin del WHILE

	COMMIT TRANSACTION tImportarOperacionesXML
	END TRY

	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION tImportarOperacionesXML;
		END;

		INSERT INTO dbo.DBErrors    VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		SET @outResultCode = 50005;

	END CATCH

	SET NOCOUNT OFF;
END