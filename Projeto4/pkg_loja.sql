@@tabelas.sql
CREATE SEQUENCE seq_fatura_ordem
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 9999
    NOCYCLE;
@@pkg_loja.pks
@@pkg_loja.pkb
-- ----------------------------------------------------------------------------
VARIABLE numFatura1 NUMBER;
VARIABLE numFatura2 NUMBER;
VARIABLE numFatura3 NUMBER;
VARIABLE numFatura4 NUMBER;
VARIABLE delCompra1 NUMBER;
VARIABLE delCompra2 NUMBER;
-- ----------------------------------------------------------------------------
BEGIN
pkg_loja.regista_cliente(111111111,'Joaquim','M',2000,'Lisboa');
pkg_loja.regista_cliente(222222222,'Beatriz','F',2003,'Lisboa');
pkg_loja.regista_produto(1234567891234,'Maca','Comida',2.99,1000);
pkg_loja.regista_produto(2345678912345,'Massa','Comida',0.99,500);
pkg_loja.regista_produto(3456789123456,'Carne','Comida',4.99,2000);
:numFatura1 := pkg_loja.regista_compra(111111111,1234567891234,5);
:numFatura2 := pkg_loja.regista_compra(111111111,2345678912345,15,:numFatura1);
:numFatura2 := pkg_loja.regista_compra(111111111,3456789123456,10,:numFatura1);
:numFatura3 := pkg_loja.regista_compra(222222222,2345678912345,20);
:numFatura4 := pkg_loja.regista_compra(222222222,3456789123456,100,:numFatura3);
:delCompra1 := pkg_loja.remove_compra(:numFatura1,3456789123456);
:delCompra2 := pkg_loja.remove_compra(:numFatura3);
END;
/
-- ----------------------------------------------------------------------------
SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM fatura;
SELECT * FROM linhafatura;
PRINT numFatura1;
PRINT numFatura3;
PRINT delCompra1;
PRINT delCompra2;
-- ----------------------------------------------------------------------------
