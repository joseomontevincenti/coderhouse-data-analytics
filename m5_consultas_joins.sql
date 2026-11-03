/*====================================================
  m5_consultas_joins.sql
  Entregable 5
====================================================*/

/*====================================================
CONSULTA 1 - VISTA BASE DEL PROYECTO (INNER JOIN)
Propósito: generar una vista enriquecida para análisis
y futura carga en Power BI.
====================================================*/

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo:
-- La consulta integra información comercial y descriptiva
-- en una sola vista apta para análisis y visualización en Power BI.



/*====================================================
CONSULTA 2 - CLIENTES SIN VENTAS (LEFT JOIN)
Propósito: identificar clientes registrados que nunca
realizaron compras.
====================================================*/

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Hallazgo:
-- No se encontraron clientes sin compras.
-- El 100% de los clientes registrados realizó al menos una venta.



/*====================================================
CONSULTA 3 - PRODUCTOS SIN VENTAS (LEFT JOIN)
Propósito: identificar artículos del catálogo que 
no registran ventas.
====================================================*/

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

-- Hallazgo:
-- No existen productos sin ventas.
-- Todo el catálogo registra al menos un movimiento comercial.


/*====================================================
CONSULTA 4 - CONSOLIDADO POR CANAL (UNION ALL)
Propósito: consolidar ventas agrupadas por un canal
generado dentro de la consulta.
====================================================*/

SELECT
    canal,
    SUM(total) AS total_canal
FROM
(
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) <= 10

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) > 10
) AS consolidado
GROUP BY canal;

-- Hallazgo:
-- El consolidado permite comparar la facturación
-- entre los canales definidos para identificar el origen con mayor aporte.
