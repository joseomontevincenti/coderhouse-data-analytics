/*====================================================
CONSULTA 1
RESUMEN EJECUTIVO MENSUAL
====================================================*/
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);
/*====================================================
CONSULTA 2
TOP 5 PRODUCTOS POR FACTURACIÓN
====================================================*/
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
/*====================================================
CONSULTA 3
CLIENTES RECURRENTES
====================================================*/
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;
/*====================================================
CONSULTA 4
MESES POR ENCIMA / DEBAJO DEL PROMEDIO
====================================================*/
WITH ventas_mensuales AS
(
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >
             (SELECT AVG(total_facturado)
              FROM ventas_mensuales)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_mensuales;
/*====================================================
HALLAZGOS DEL ANÁLISIS
======================================================
1. El id_producto = 1 es el producto con mayor facturación.
2. Todos los clientes registrados realizaron más de una compra y aparecen como clientes recurrentes.
3. El mes 3 (marzo) concentra el 100% de la facturación registrada en la base de datos.
====================================================*/
