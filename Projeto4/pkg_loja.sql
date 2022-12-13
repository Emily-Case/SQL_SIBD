@tabelas.sql
@pkg_loja.pks
@pkg_loja.pkb

CREATE SEQUENCE seq_fatura_ordem
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 9999
    NOCYCLE;

VARIABLE numFatura1 NUMBER;
VARIABLE numFatura2 NUMBER;
VARIABLE numFatura3 NUMBER;

BEGIN

pkg_loja.regista_cliente(111111111,'Joaquim','M',2003,'Lisboa');
pkg_loja.regista_cliente(222222222,'Patrícia','F',1992,'Porto');
pkg_loja.regista_produto(1234567891234,'Maça','Comida',2.99,1000);
pkg_loja.regista_produto(2345678912345,'Massa','Comida',0.99,1000);
:numFatura1 := pkg_loja.regista_compra(111111111, 1234567891234, 2);
:numFatura2 := pkg_loja.regista_compra(111111111, 2345678912345, 10, :numFatura1);
:numFatura3 := pkg_loja.regista_compra(222222222, 2345678912345, 20);
END;
/
SELECT * FROM cliente;
SELECT * FROM produto;
PRINT numFatura1;
PRINT numFatura3;
DROP SEQUENCE seq_fatura_ordem;
