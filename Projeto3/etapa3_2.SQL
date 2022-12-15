-- username: sibd20@difcul
-- password: group20sibd
-- SIBD 2022/2023   Etapa 3   Grupo 20
-- Inês Luz      fc57552 (TP13)
-- José Sá       fc58200 (TP11)
-- Marta Lorenço fc58249 (TP15)
-- Yichen Cao    fc58165 (TP11)

-- EXERCÍCIO 1
--Gets all female customers with last name dias that have receipts from 2021
SELECT C.nif NIF, C.nome Nome, (2022 - C.Nascimento) Idade, P.ean13 EAN13, P.nome Nome_Produto, F.numero Número_Fatura, F.data Data_Fatura
FROM cliente C, fatura F, produto P, linhafatura L
WHERE (C.genero = 'F')
AND (C.nif = F.cliente)
AND (F.numero = L.fatura)
AND (P.ean13 = L.produto)
AND (P.categoria = 'Beleza')
AND (TO_CHAR(F.data, 'YYYY') = '2021')
AND (C.nome LIKE '%Dias')
ORDER BY (2022 - C.Nascimento), C.nome ASC, F.numero, P.nome DESC;


-- EXERCÍCIO 2
-- nif and name of guys who
    --> never bought beauty products regardless of year
    --> bought 2 times or less of clothes in 2021
SELECT C.nif, C.nome
FROM cliente C
WHERE (C.genero = 'M')
AND (NOT EXISTS (SELECT C.nome  -- selects buyers who bought clothes less than 2 times in 2021
                 FROM cliente C, fatura F1 
                 WHERE (C.nif = F1.cliente)
                 AND (F1.numero IN (SELECT F2.numero -- needs this to count fatura as only instance
                                    FROM fatura F2, linhafatura LF2, produto P2 
                                    WHERE (F2.numero = LF2.fatura)
                                    AND (LF2.produto = P2.ean13) 
                                    AND (P2.categoria = 'Roupa') -- make sure its clothes
                                    AND (TO_CHAR(F2.data, 'YYYY') = '2021'))) -- make sure its 2021
                 HAVING (COUNT(*) >= 3)
                 GROUP BY C.nome))
AND (NOT EXISTS (SELECT * -- selects nobody here EVER bought beauty products
                 FROM fatura F3, linhafatura LF3, produto P3 
                 WHERE (F3.cliente = C.nif)
                 AND (F3.numero = LF3.fatura)
                 AND (LF3.produto = P3.ean13)
                 AND (P3.categoria = 'Beleza'))) -- make sure its beauty
ORDER BY C.nome ASC, C.nif DESC;


-- EXERCÍCIO 3
-- Gets all the food products that:
    --> are cheaper than the average of ALL products
    --> have been bought at least once by every client in Porto, during the morning (between 8h and 12h)
SELECT P1.categoria, P1.nome, P1.ean13, P1.preco, P1.stock
FROM produto P1
WHERE EXISTS (SELECT C.nif, C.localidade, F.cliente, F.data
                FROM cliente C, fatura F, linhafatura LF
                WHERE (C.nif = F.cliente)
                AND (F.numero = LF.fatura)
                AND (LF.produto = P1.ean13)
                AND (C.localidade = 'Porto')
                AND (TO_CHAR(F.data,'HH24') >= '08')
                AND (TO_CHAR(F.data, 'HH24') <= '12')
                AND (P1.categoria = 'Comida')
                AND (P1.preco < (SELECT AVG(P2.preco)
                    FROM produto P2))
)
ORDER BY P1.preco DESC, P1.ean13 ASC;

-- EXERCÍCIO 4
SELECT C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY') AS ano, SUM(P.preco * L.unidades) AS gasto
FROM cliente C, fatura F, produto P, linhaFatura L
WHERE (C.nif = F.cliente)
AND (F.numero = L.fatura)
AND (L.produto = P.ean13)
GROUP BY C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY')
ORDER BY ano DESC, C.genero ASC;


--working version: tedious
SELECT C1.nif, C1.nome, C1.genero,TO_CHAR(F1.data,'YYYY') AS ano, 
        SUM(P1.preco * L1.unidades) AS spending
FROM cliente C1, fatura F1, produto P1, linhaFatura L1
WHERE (C1.nif = F1.cliente)
AND (F1.numero = L1.fatura)
AND (L1.produto = P1.ean13)
GROUP BY C1.nif, C1.nome, C1.genero, TO_CHAR(F1.data,'YYYY')
HAVING (SUM(P1.preco * L1.unidades) IN (SELECT CL2.gastoo FROM( --SELECTS only
                                        (SELECT ano, gender, MAX(CL.gasto) AS gastoo--SELECTS MAX
                                        FROM ( SELECT C.nif AS nif, C.nome AS name,
                                                    C.genero AS gender, TO_CHAR(F.data,'YYYY') AS ano,
                                                    SUM(P.preco * L.unidades) AS gasto
                                                FROM cliente C, fatura F, produto P, linhaFatura L
                                                WHERE (C.nif = F.cliente)
                                                AND (F.numero = L.fatura)
                                                AND (L.produto = P.ean13)
                                                GROUP BY C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY')) CL
                                        GROUP BY ano, gender
                                        ORDER BY ano DESC, gender ASC)) CL2))
ORDER BY ano DESC, C1.genero ASC


--testing grounds
SELECT C1.nif, C1.nome, C1.genero,TO_CHAR(F1.data,'YYYY') AS ano, 
        SUM(P1.preco * L1.unidades) AS spending
FROM cliente C1, fatura F1, produto P1, linhaFatura L1
WHERE (C1.nif = F1.cliente)
AND (F1.numero = L1.fatura)
AND (L1.produto = P1.ean13)
GROUP BY C1.nif, C1.nome, C1.genero, TO_CHAR(F1.data,'YYYY')
HAVING (SUM(P1.preco * L1.unidades) IN --(SELECT CL2.gastoo FROM( --SELECTS only
                                        (SELECT MAX(CL.gasto) AS gastoo--, ano, gender --SELECTS MAX
                                        FROM ( SELECT C.nif AS nif, C.nome AS name,
                                                    C.genero AS gender, TO_CHAR(F.data,'YYYY') AS ano,
                                                    SUM(P.preco * L.unidades) AS gasto
                                                FROM cliente C, fatura F, produto P, linhaFatura L
                                                WHERE (C.nif = F.cliente)
                                                AND (F.numero = L.fatura)
                                                AND (L.produto = P.ean13)
                                                GROUP BY C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY')) CL
                                        GROUP BY ano, gender
                                        ORDER BY ano DESC, gender ASC))-- CL2))
ORDER BY ano DESC, C1.genero ASC


SELECT C1.nif, C1.nome, C1.genero,TO_CHAR(F1.data,'YYYY') AS ano, 
        SUM(P1.preco * L1.unidades) AS spending
FROM cliente C1, fatura F1, produto P1, linhaFatura L1
WHERE (C1.nif = F1.cliente)
AND (F1.numero = L1.fatura)
AND (L1.produto = P1.ean13)
GROUP BY C1.nif, C1.nome, C1.genero, TO_CHAR(F1.data,'YYYY')
HAVING (SUM(P1.preco * L1.unidades) IN (SELECT MAX(CL.gasto) AS gastoo
                                        FROM ( SELECT C.nif AS nif, C.nome AS name,
                                                    C.genero AS gender, TO_CHAR(F.data,'YYYY') AS ano,
                                                    SUM(P.preco * L.unidades) AS gasto
                                                FROM cliente C, fatura F, produto P, linhaFatura L
                                                WHERE (C.nif = F.cliente)
                                                AND (F.numero = L.fatura)
                                                AND (L.produto = P.ean13)
                                                GROUP BY C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY')) CL
                                        GROUP BY ano, gender))
ORDER BY ano DESC, C1.genero ASC

-- shows everything except nif and
SELECT ano, gender, MAX(CL.gasto)--, CL.nif
FROM (SELECT C.nif AS nif, C.nome AS namie,
             C.genero AS gender, TO_CHAR(F.data,'YYYY') AS ano,
             SUM(P.preco * L.unidades) AS gasto
      FROM cliente C, fatura F, produto P, linhaFatura L
      WHERE (C.nif = F.cliente)
      AND (F.numero = L.fatura)
      AND (L.produto = P.ean13)
      GROUP BY C.nif, C.nome, C.genero, TO_CHAR(F.data,'YYYY')) CL
      --RIGHT OUTER JOIN cliente C2 ON C2.nif = CL.nif
GROUP BY ano, gender
ORDER BY ano DESC, gender ASC;
