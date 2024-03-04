/** Ejercicio 1 **/
/* Punto 1 */

SELECT *
FROM Cliente
WHERE apellido LIKE "Pe%"
ORDER BY DNI

/* Punto 2 */

SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente NATURAL JOIN Factura
WHERE fecha >= "1/1/2017" AND fecha <= "31/12/2017"
EXCEPT
(
    SELECT nombre,apellido,DNI,telefono,direccion
    FROM Cliente NATURAL JOIN Factura
    WHERE fecha < "1/1/2017" OR fecha > "31/12/2017"
)

/* Punto 3 */

SELECT nombre,descripcion,precio,stock
FROM Cliente,Factura,Detalle,Producto
WHERE DNI = "45789456"
EXCEPT
(
    SELECT nombre,descripcion,precio,stock
    FROM Cliente,Factura,Detalle,Producto
    WHERE apellido = "Garcia"
)

/* Punto 4 */

SELECT nombreP,descripcion,precio,stock
FROM Producto
WHERE idProducto NOT IN( 
    SELECT idProducto 
    FROM Producto p
        INNER JOIN Detalle d ON (p.idProducto = d.idProducto)
        INNER JOIN Factura f ON (d.nroTicket = f.nroTicket)
        INNER JOIN Cliente c ON (f.idCliente = d.idCliente)
    WHERE c.telefono like "221%" 
    )
ORDER BY nombreP

/* Punto 5 */

SELECT nombreP,descripcion,precio,SUM(cantidad) AS cantidadVendida
FROM Producto p LEFT JOIN Detalle d ON (p.idProducto = d.idProducto)
GROUP BY p.idProducto,nombreP,descripcion,precio

/* Punto 6 */

SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE nombreP = "prod1" AND c.idCliente IN
    (
        SELECT c.idCliente
        FROM Cliente c
            INNER JOIN Factura f ON (c.idCliente = f.idCliente)
            INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
            INNER JOIN Producto p ON (d.idProducto = p.idProducto)
        WHERE nombreP = "prod2"
    )
EXCEPT
(
SELECT nombre,apellido,DNI,telefono,direccion
FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE nombreP = "prod3"
)

/* Punto 7 */

SELECT f.nroTicket,total,fecha,hora,DNI
FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE nombreP = "prod38" OR (fecha >= "1/1/2019" AND fecha <= "31/12/2019")

/* Punto 8 */

INSERT INTO Cliente (nombre,apellido,DNI,telefono,direccion,idCliente) VALUES ("Jorge Luis", "Castor", "40578999", "221-400789", "11 e/500 y 501 nro: 2587", "500002")

/* Punto 9 */

SELECT nroTicket,total,fecha,hora
FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE nombre = "Jorge" AND apellido = "Perez" AND c.idCliente NOT IN 
(
SELECT c.idCliente
FROM Cliente c
    INNER JOIN Factura f ON (c.idCliente = f.idCliente)
    INNER JOIN Detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN Producto p ON (d.idProducto = p.idProducto)
WHERE nombre = "Jorge" AND apellido = "Perez" AND nombreP = "Z"   
)

/* Punto 10 */

SELECT DNI,apellido,nombre
FROM Cliente NATURAL JOIN Factura
GROUP BY idCliente,DNI,apellido,nombre
HAVING SUM(total) > 10000000


/** Ejercicio 2 **/

/* Punto 1 */

SELECT RAZON_SOCIAL,direccion,telef
FROM AGENCIA a
    INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
    INNER JOIN CIUDAD c ON (v.cpOrigen = c.CODIGOPOSTAL)
    INNER JOIN Cliente cl ON (v.DNI = cl.DNI)
WHERE c.nombreCiudad = "La Plata" AND cl.apellido = "Roma"
ORDER BY RAZON_SOCIAL,telef

/* Punto 2 */

SELECT fecha,hora,cl.*,orig.nombreCiudad,dest.nombreCiudad
FROM VIAJE v
    INNER JOIN CIUDAD orig ON (v.cpOrigen = c.CODIGOPOSTAL)
    INNER JOIN CIUDAD dest ON (v.cpDestino = c.CODIGOPOSTAL)
    INNER JOIN Cliente cl ON (v.DNI = cl.DNI)
WHERE fecha >= "1/1/2019" AND fecha <= "31/12/2019" AND descripcion LIKE "%demorado%"

/* Punto 3 */

SELECT a.*
FROM AGENCIA a
    LEFT JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
WHERE email LIKE "%@jmail.com" OR (fecha >= "1/1/2019" AND "31/12/2019")

/* Punto 4 */

SELECT cl.*
FROM CLIENTE cl
    INNER JOIN VIAJE v ON (cl.DNI = v.DNI)
    INNER JOIN CIUDAD c ON (v.cpDestino = c.CODIGOPOSTAL)
WHERE c.nombreCiudad = "Coronel Brandsen" AND cl.DNI NOT IN
(
    SELECT DNI
    FROM CLIENTE cl
        INNER JOIN VIAJE v ON (cl.DNI = v.DNI)
        INNER JOIN CIUDAD c ON (v.cpDestino = c.CODIGOPOSTAL)
    WHERE c.nombreCiudad <> "Coronel Brandsen" AND cl.DNI NOT IN
)

/* Punto 5 */

SELECT COUNT(*) as 'Cantidad de Viajes'
FROM AGENCIA a 
    INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.razon_social)
    INNER JOIN CIUDAD c ON (v.cpDestino = c.CODIGOPOSTAL)
WHERE a.RAZON_SOCIAL = "Taxi Y" AND c.nombreCiudad = "Villa Elisa"

/* Punto 6 */

SELECT nombre,apellido,direccion,telefono
FROM CLIENTE c
WHERE NOT EXISTS
(
    SELECT *
    FROM AGENCIA a
    WHERE NOT EXISTS
    (
        SELECT *
        FROM VIAJE v
        WHERE (v.DNI = c.DNI) AND (a.RAZON_SOCIAL = v.razon_social)
    )
) /* IMPORTANTE para todos = doble negacion de exists */

/* Punto 7 */

UPDATE CLIENTE SET telefono = "221-4400897" WHERE DNI = "38495444"

/* Punto 8 */

SELECT RAZON_SOCIAL,direccion,telef 
FROM AGENCIA a
    INNER JOIN VIAJE v on (a.RAZON_SOCIAL = v.razon_social)
GROUP BY RAZON_SOCIAL
HAVING COUNT(*) >=ALL
(
    SELECT COUNT(*)
    FROM VIAJE v 
    GROUP BY v.razon_social
)

/* Punto 9 */

SELECT nombre,apellido,direccion,telefono
FROM CLIENTE c
    INNER JOIN VIAJE v ON (c.DNI = v.DNI)
GROUP BY v.DNI
HAVING COUNT(*) >= 10

/* Punto 10 */

DELETE FROM CLIENTE WHERE DNI="40325692"


/** Ejercicio 3 **/

/* Punto 1 */

SELECT cl.nombre,cl.anioFundacion
FROM Club cl
    LEFT JOIN Estadio e ON (cl.codigoClub = e.codigoClub)
    INNER JOIN Ciudad ci ON (cl.codigoCiudad = ci.codigoCiudad)
WHERE ci.nombre = "La Plata" AND e.codigoEstadio IS NULL

/* Punto 2 */

SELECT cl.nombre
FROM Club cl
WHERE cl.codigoClub NOT IN
(
    SELECT cl.codigoClub
    FROM Club cl
        INNER JOIN ClubJugador cj ON (cl.codigoClub = cj.codigoClub)
        INNER JOIN Jugador j ON (j.DNI = cj.DNI)
        INNER JOIN Ciudad ci ON (j.codigoCiudad = ci.codigoCiudad) 
    WHERE ci.nombre = "Berisso"
)

/* Punto 3 */

SELECT j.DNI,j.nombre,j.apellido
FROM Jugador j 
    INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
    INNER JOIN Club cl ON (cj.codigoClub = cl.codigoClub)
WHERE cl.nombre = "Gimnasia y Esgrima La Plata"

/* Punto 4 */

SELECT j.DNI,j.nombre,j.apellido
FROM Jugador j 
    INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
    INNER JOIN Club cl ON (cj.codigoClub = cl.codigoClub)
    INNER JOIN Ciudad ci ON (cl.codigoCiudad = ci.codigoCiudad)
WHERE j.edad > 29 AND ci.nombre = "Cordoba"

/* Punto 5 */

SELECT cl.nombre,AVG(j.edad) as 'Edad Promedio'
FROM Club cl
    INNER JOIN ClubJugador cj ON (cl.codigoClub = cj.codigoClub)
    INNER JOIN Jugador j ON (cj.DNI = j.DNI)
WHERE cj.hasta IS NULL
GROUP BY cl.codigoClub,cl.nombre,j.edad

/* Punto 6 */

SELECT j.nombre,j.apellido,j.edad,COUNT(*) as 'Cantidad de Equipos'
FROM Jugador j 
    INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
GROUP BY j.nombre,j.apellido,j.edad

/* Punto 7 */ 

SELECT cl.nombre 
FROM Club cl 
WHERE cl.codigoClub NOT IN 
(
    SELECT cj.codigoClub
    FROM ClubJugador cj
        INNER JOIN Jugador j ON (cj.DNI = j.DNI)
        INNER JOIN Ciudad ci ON (j.codigoCiudad = ci.codigoCiudad)
    WHERE ci.nombre = "Mar Del Plata"
)

/* Punto 8 */

SELECT j.nombre,j.apellido 
FROM Jugador j
WHERE NOT EXISTS 
(        
    SELECT *
    FROM Club cl
    WHERE NOT EXISTS
    (
        SELECT *
        FROM ClubJugador cj
        WHERE cj.codigoClub = cl.codigoClub AND cj.DNI = j.DNI
    )
)

/* Punto 9 */

INSERT INTO Club(codigoClub,nombre,anioFundacion,codigoCiudad(FK)) WHERE VALUES (
    "1234",
    "Estrella de Berisso",
    "1921"
    (SELECT ci.codigoCiudad FROM Ciudad ci WHERE ci.nombre="Berisso")
    )


/** Ejercicio 4 **/

/* Punto 1 */

SELECT DNI,Legajo,Apellido,Nombre
FROM ALUMNO NATURAL JOIN PERSONA
WHERE Año_Ingreso < "2014"

/* Punto 2 */

SELECT DNI,Matricula,p.Apellido,p.Nombre
FROM PROFESOR NATURAL JOIN PERSONA p NATURAL JOIN PROFESOR_CURSO pc INNER JOIN CURSO c ON (pc.Cod_Curso = c.Cod_Curso)
WHERE Duracion > 100
ORDER BY DNI

/* Punto 3 */