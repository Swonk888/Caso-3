--VIEW
IF OBJECT_ID('Vista', 'V') IS NOT NULL
    DROP VIEW Vista;
GO
IF OBJECT_ID('dbo.indexado', 'V') IS NOT NULL
    DROP VIEW dbo.indexado;
GO
IF OBJECT_ID('dinamico', 'V') IS NOT NULL
    DROP VIEW dinamico;
GO
CREATE VIEW Vista AS
SELECT dbo.contrato.descripcion, dbo.proceso.proceso_id, dbo.proceso.clasificacion, dbo.desecho_movimientos.posttime, dbo.desecho_movimientos.responsible_name, dbo.desecho_movimientos.reci_desecho_cantidad, 
                  dbo.ubicaciones.descripcion AS Expr1, dbo.paises.nombre, dbo.productores_residuos.nombre AS Expr2, dbo.productores_residuos.porcentaje_carbon, dbo.productores_residuos.balance
FROM     dbo.contrato INNER JOIN
                  dbo.proceso ON dbo.contrato.contrato_id = dbo.proceso.contrato_id INNER JOIN
                  dbo.desecho_movimientos ON dbo.proceso.proceso_id = dbo.desecho_movimientos.proceso_id INNER JOIN
                  dbo.ubicaciones ON dbo.contrato.ubicacion_id = dbo.ubicaciones.ubicacion_id AND dbo.desecho_movimientos.ubicacion_id = dbo.ubicaciones.ubicacion_id INNER JOIN
                  dbo.paises ON dbo.ubicaciones.pais_id = dbo.paises.pais_id INNER JOIN
                  dbo.productores_residuos ON dbo.desecho_movimientos.productor_id = dbo.productores_residuos.productor_id AND dbo.ubicaciones.ubicacion_id = dbo.productores_residuos.ubicaicon_id
				  Where dbo.contrato.contrato_id < 12
GO

select * from Vista;

GO
--Indexed View
CREATE VIEW dbo.indexado
WITH SCHEMABINDING
AS
    SELECT dbo.contrato.descripcion, dbo.proceso.proceso_id, dbo.proceso.clasificacion, dbo.desecho_movimientos.posttime, dbo.desecho_movimientos.responsible_name, dbo.desecho_movimientos.reci_desecho_cantidad, 
                  dbo.ubicaciones.descripcion AS Expr1, dbo.paises.nombre, dbo.productores_residuos.nombre AS Expr2, dbo.productores_residuos.porcentaje_carbon, dbo.productores_residuos.balance
    FROM     dbo.contrato INNER JOIN
                  dbo.proceso ON dbo.contrato.contrato_id = dbo.proceso.contrato_id INNER JOIN
                  dbo.desecho_movimientos ON dbo.proceso.proceso_id = dbo.desecho_movimientos.proceso_id INNER JOIN
                  dbo.ubicaciones ON dbo.contrato.ubicacion_id = dbo.ubicaciones.ubicacion_id AND dbo.desecho_movimientos.ubicacion_id = dbo.ubicaciones.ubicacion_id INNER JOIN
                  dbo.paises ON dbo.ubicaciones.pais_id = dbo.paises.pais_id INNER JOIN
                  dbo.productores_residuos ON dbo.desecho_movimientos.productor_id = dbo.productores_residuos.productor_id AND dbo.ubicaciones.ubicacion_id = dbo.productores_residuos.ubicaicon_id
    WHERE dbo.contrato.contrato_id < 12

GO

CREATE UNIQUE CLUSTERED INDEX IX_Vista ON indexado (responsible_name);

select * from indexado


--Dynamic View
DECLARE @sql NVARCHAR(MAX)

SET @sql = 'CREATE VIEW dinamico AS ' + CHAR(13) +
           'SELECT TOP 100 PERCENT dbo.contrato.descripcion, dbo.proceso.proceso_id, dbo.proceso.clasificacion, dbo.desecho_movimientos.posttime, dbo.desecho_movimientos.responsible_name, ' + CHAR(13) +
           'dbo.desecho_movimientos.reci_desecho_cantidad, dbo.ubicaciones.descripcion AS Expr1, dbo.paises.nombre, dbo.productores_residuos.nombre AS Expr2, ' + CHAR(13) +
           'dbo.productores_residuos.porcentaje_carbon, dbo.productores_residuos.balance' + CHAR(13) +
           'FROM dbo.contrato' + CHAR(13) +
           'INNER JOIN dbo.proceso ON dbo.contrato.contrato_id = dbo.proceso.contrato_id' + CHAR(13) +
           'INNER JOIN dbo.desecho_movimientos ON dbo.proceso.proceso_id = dbo.desecho_movimientos.proceso_id' + CHAR(13) +
           'INNER JOIN dbo.ubicaciones ON dbo.contrato.ubicacion_id = dbo.ubicaciones.ubicacion_id AND dbo.desecho_movimientos.ubicacion_id = dbo.ubicaciones.ubicacion_id' + CHAR(13) +
           'INNER JOIN dbo.paises ON dbo.ubicaciones.pais_id = dbo.paises.pais_id' + CHAR(13) +
           'INNER JOIN dbo.productores_residuos ON dbo.desecho_movimientos.productor_id = dbo.productores_residuos.productor_id AND dbo.ubicaciones.ubicacion_id = dbo.productores_residuos.ubicaicon_id' + CHAR(13) +
           'WHERE dbo.contrato.contrato_id < 12' + CHAR(13) +
           'ORDER BY dbo.productores_residuos.balance'

EXEC sp_executesql @sql;

GO

Select * from dinamico;
