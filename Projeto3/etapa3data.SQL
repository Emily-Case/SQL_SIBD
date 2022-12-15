-- ----------------------------------------------------------------------------
DROP TABLE linhafatura;
DROP TABLE fatura;
DROP TABLE produto CASCADE CONSTRAINTS;
DROP TABLE cliente;
------------------------------------------------
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy-mm-dd'; 
--alters date format because session might have a different one--
------------------------------------------------
CREATE TABLE cliente (
nif NUMBER (9),
nome VARCHAR (20) CONSTRAINT nn_cliente_nome NOT NULL,
genero CHAR (1) CONSTRAINT nn_cliente_genero NOT NULL,
nascimento NUMBER (4) CONSTRAINT nn_cliente_nascimento NOT NULL, -- Ano.
localidade VARCHAR (20) CONSTRAINT nn_cliente_localidade NOT NULL,
--
CONSTRAINT pk_cliente
PRIMARY KEY (nif),
--
CONSTRAINT ck_cliente_nif -- RIA 16.
CHECK (nif BETWEEN 100000000 AND 999999999),
--
CONSTRAINT ck_cliente_genero -- RIA 17.
CHECK (genero IN ('F', 'M')),
--
CONSTRAINT ck_cliente_nascimento
CHECK (nascimento >= 1900) -- Valor razoável.
);
-- ----------------------------------------------------------------------------
CREATE TABLE produto (
ean13 NUMBER (13),
nome VARCHAR (20) CONSTRAINT nn_produto_nome NOT NULL,
categoria CHAR (7) CONSTRAINT nn_produto_categoria NOT NULL,
preco NUMBER (6,2) CONSTRAINT nn_produto_preco NOT NULL,
stock NUMBER (4) CONSTRAINT nn_produto_stock NOT NULL,
--
CONSTRAINT pk_produto
PRIMARY KEY (ean13),
--
CONSTRAINT ck_produto_ean13 -- RIA 11.
CHECK (ean13 BETWEEN 1000000000000 AND 9999999999999),
--
CONSTRAINT ck_produto_categoria -- RIA 13.
CHECK (categoria IN ('Comida', 'Roupa', 'Beleza', 'Animais')),
--
CONSTRAINT ck_produto_preco -- RIA 14.
CHECK (preco > 0.0),
--
CONSTRAINT ck_produto_stock
CHECK (stock >= 0)
);
-- ----------------------------------------------------------------------------
CREATE TABLE fatura (
numero NUMBER (6),
data DATE CONSTRAINT nn_fatura_data NOT NULL,
cliente CONSTRAINT nn_fatura_cliente NOT NULL,
--
CONSTRAINT pk_fatura
PRIMARY KEY (numero),
--
CONSTRAINT fk_fatura_cliente
FOREIGN KEY (cliente)
REFERENCES cliente (nif),
--
CONSTRAINT ck_fatura_numero -- RIA 18.
CHECK (numero >= 1)
);

INSERT INTO fatura(numero, data, cliente) 
	VALUES (111111, '2022-01-27',234567891);
-- ----------------------------------------------------------------------------
CREATE TABLE linhafatura (
fatura,
produto,
unidades NUMBER (4) CONSTRAINT nn_linhafatura_unidades NOT NULL,
--
CONSTRAINT pk_linhafatura
PRIMARY KEY (fatura, produto),
--
CONSTRAINT fk_linhafatura_fatura
FOREIGN KEY (fatura)
REFERENCES fatura (numero),
--
CONSTRAINT fk_linhafatura_produto
FOREIGN KEY (produto)
REFERENCES produto (ean13),
--
CONSTRAINT ck_linhafatura_unidades -- RIA 19.
CHECK (unidades > 0)
);

-- ----------------------------------------------------------------------------
-- Sistemas de Informação e Bases de Dados - António Ferreira, DI-FCUL.
-- Dados para as tabelas da etapa 3 do projeto de 2022/2023.
-- ----------------------------------------------------------------------------

ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY HH24:MI';

-- ----------------------------------------------------------------------------

DELETE FROM linhafatura;
DELETE FROM fatura;
DELETE FROM produto;
DELETE FROM cliente;

-- ----------------------------------------------------------------------------
--                                                                     Produtos

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (1111111111111, 'Bolo', 'Comida', 1.11, 11);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (2222222222222, 'Ovos', 'Comida', 2.22, 22);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (2222222222223, 'Ovos..TWO', 'Comida', 2.33, 33);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (3333333333333, 'Camisa', 'Roupa', 33.33, 33);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (4444444444444, 'Casaco', 'Roupa', 44.44, 44);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (5555555555555, 'Verniz', 'Beleza', 5.55, 55);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (6666666666666, 'Batom', 'Beleza', 6.66, 66);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (7777777777777, 'Trela', 'Animais', 7.77, 77);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (8888888888888, 'Alpista', 'Animais', 8.88, 88);

INSERT INTO produto (ean13, nome, categoria, preco, stock)
     VALUES (9999999999999, 'T-shirt', 'Roupa', 99.99, 99);

-- ----------------------------------------------------------------------------
--                                        Clientes, Faturas, e Linhas de Fatura

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (111111111, 'Diogo Gaspar', 'M', 1931, 'Lisboa');
-- haha. transgender :)
-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (101, TO_DATE('01.01.2020 10:00',
                          'DD.MM.YYYY HH24:MI'), 111111111);

INSERT INTO fatura (numero, data, cliente)
     VALUES (102, TO_DATE('11.01.2020 10:00',
                          'DD.MM.YYYY HH24:MI'), 111111111);

INSERT INTO fatura (numero, data, cliente)
     VALUES (103, TO_DATE('11.11.2020 10:00',
                          'DD.MM.YYYY HH24:MI'), 111111111);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (101, 3333333333333, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (102, 4444444444444, 2);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (103, 3333333333333, 3);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (222222222, 'Bruno Nunes', 'M', 1992, 'Lisboa');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (201, TO_DATE('02.02.2022 10:00',
                          'DD.MM.YYYY HH24:MI'), 222222222);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (201, 3333333333333, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (201, 2222222222222, 1);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (333333333, 'Carlos Dias', 'M', 1993, 'Lisboa');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (301, TO_DATE('03.03.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 333333333);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (301, 5555555555555, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (301, 3333333333333, 1);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (444444444, 'Daniela Santos', 'F', 1994, 'Porto');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (401, TO_DATE('04.04.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 444444444);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (401, 1111111111111, 16);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (401, 2222222222222, 1);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (555555555, 'Eduarda Dias', 'F', 1995, 'Lisboa');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (501, TO_DATE('05.05.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 555555555);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (501, 5555555555555, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (501, 6666666666666, 1);

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (502, TO_DATE('05.05.2022 10:00',
                          'DD.MM.YYYY HH24:MI'), 555555555);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (502, 5555555555555, 1);
-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (666666666, 'Filipe Rocha', 'M', 1996, 'Porto');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (601, TO_DATE('06.06.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 666666666);

INSERT INTO fatura (numero, data, cliente)
     VALUES (602, TO_DATE('16.06.2021 16:00',
                          'DD.MM.YYYY HH24:MI'), 666666666);

INSERT INTO fatura (numero, data, cliente)
     VALUES (603, TO_DATE('26.06.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 666666666);

INSERT INTO fatura (numero, data, cliente)
     VALUES (604, TO_DATE('26.06.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 666666666);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (601, 3333333333333, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (601, 4444444444444, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (601, 9999999999999, 1);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (602, 4444444444444, 2);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (602, 2222222222223, 2);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (603, 1111111111111, 3);

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (604, 9999999999999, 1);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (777777777, 'Helena Dias', 'F', 1997, 'Lisboa');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (701, TO_DATE('07.07.2021 10:00',
                          'DD.MM.YYYY HH24:MI'), 777777777);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (701, 6666666666666, 3);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (888888888, 'Joaquim Soares', 'M', 1948, 'Lisboa');

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (899999999, 'Joaquim Soares', 'M', 1999, 'Lisboa');
-- ---

-- Nunca fez uma compra.
-- INSERT INTO fatura (numero, data, cliente)
--      VALUES (801, TO_DATE('08.08.2021 10:00',
--                           'DD.MM.YYYY HH24:MI'), 888888888);

-- ---

-- Nunca fez uma compra.
-- INSERT INTO linhafatura (fatura, produto, unidades)
--      VALUES (801, 1111111111111, 1);

-- ----------------------------------------------------------------------------

INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
     VALUES (999999999, 'Leonor Dias', 'F', 1949, 'Lisboa');

-- ---

INSERT INTO fatura (numero, data, cliente)
     VALUES (901, TO_DATE('09.09.2019 10:00',
                          'DD.MM.YYYY HH24:MI'), 999999999);

-- ---

INSERT INTO linhafatura (fatura, produto, unidades)
     VALUES (901, 5555555555555, 1);

-- ----------------------------------------------------------------------------

COMMIT;

-- ----------------------------------------------------------------------------
