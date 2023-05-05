
/*IF OBJECT_ID('dbo.RegistrarVentas', 'P') IS NOT NULL
DROP PROCEDURE dbo.RegistrarVentas;
*/

CREATE TYPE VentasType AS TABLE (
venta_id INT,
producto_id SMALLINT,
fecha DATETIME,
cantidad SMALLINT,
moneda_id SMALLINT,
tipo_cambio_id int,
tipo_cambio DECIMAL(10,4)
)
GO


CREATE PROCEDURE [dbo].[RegistrarVentas]
    @ventasTabla VentasType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InicieTransaccion BIT = 0;
    DECLARE @tipo_cambio DECIMAL(10,4), @monto DECIMAL(10,2);
    DECLARE @producto_id SMALLINT, @cantidad SMALLINT, @venta_id INT;

    SET @tipo_cambio = (SELECT TOP 1 tipo_cambio FROM @ventasTabla ORDER BY NEWID());
    SET @producto_id = (SELECT TOP 1 producto_id FROM @ventasTabla ORDER BY NEWID());
    SET @venta_id = (SELECT TOP 1 venta_id FROM @ventasTabla ORDER BY NEWID());
    SET @cantidad = (SELECT TOP 1 cantidad FROM @ventasTabla ORDER BY NEWID());

    IF @@TRANCOUNT = 0 BEGIN
        SET @InicieTransaccion = 1;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        BEGIN TRANSACTION;
    END;

    BEGIN TRY
	
        SET @monto = @cantidad * (SELECT precio FROM productos WHERE producto_id = @producto_id) * @tipo_cambio;
        INSERT INTO ventas (producto_id, monto, fecha, cantidad, moneda_id, tipo_cambio, tipo_cambio_id)
        SELECT producto_id, @monto, fecha, cantidad, moneda_id, tipo_cambio, tipo_cambio_id
        FROM @ventasTabla;
        UPDATE productos_producidos SET productos_producidos.cantidad = productos_producidos.cantidad - @cantidad;
		
        IF @InicieTransaccion = 1 BEGIN
            COMMIT;
        END;
    END TRY
    BEGIN CATCH
        IF @InicieTransaccion = 1 BEGIN
            ROLLBACK;
        END;

        DECLARE @ErrorNumber INT = ERROR_NUMBER(),
                @ErrorSeverity INT = ERROR_SEVERITY(),
                @ErrorState INT = ERROR_STATE(),
                @Message VARCHAR(200) = ERROR_MESSAGE(),
                @CustomError INT = 2001;

        RAISERROR('%s - Error Number: %i', 
            @ErrorSeverity, @ErrorState, @Message, @CustomError);
    END CATCH
END
GO

/*
DECLARE @ventasTabla VentasType;
INSERT INTO @ventasTabla (producto_id, fecha, cantidad, moneda_id, tipo_cambio, tipo_cambio_id) 
VALUES (3, '2023-03-02 06:00:00',2,1, 1, 1);


EXEC RegistrarVentas @ventasTabla;*/
