CREATE SEQUENCE seq_fatura_ordem
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 9999
    NOCYCLE;

@tabelas.sql
@pkg_loja.pks
@pkg_loja.pkb

VARIABLE numFatura1 NUMBER;
VARIABLE numFatura2 NUMBER;
VARIABLE numFatura3 NUMBER;
VARIABLE delCompra1 NUMBER;
VARIABLE delCompra2 NUMBER;
VARIABLE delCompra3 NUMBER;

BEGIN
pkg_loja.regista_cliente(111111111,'Joaquim','M',2000,'Lisboa');
pkg_loja.regista_cliente(222222222,'Beatriz','F',2003,'Lisboa');
pkg_loja.regista_produto(1234567891234,'Maça','Comida',2.99,1000);
pkg_loja.regista_produto(2345678912345,'Massa','Comida',0.99,500);
pkg_loja.regista_produto(3456789123456,'Carne','Comida',4.99,2000);
:numFatura1 := pkg_loja.regista_compra(111111111, 1234567891234, 5);
:numFatura2 := pkg_loja.regista_compra(111111111, 2345678912345, 15, :numFatura1);
:numFatura2 := pkg_loja.regista_compra(111111111, 3456789123456, 10, :numFatura1);
:numFatura3 := pkg_loja.regista_compra(222222222, 2345678912345, 20);
:delCompra1 := pkg_loja.remove_compra(:numFatura2, 2345678912345);
:delCompra2 := pkg_loja.remove_compra(:numFatura2, 1234567891234);
:delCompra3 := pkg_loja.remove_compra(:numFatura3, 2345678912345);
END;
/
SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM fatura;
SELECT * FROM linhafatura;
PRINT delCompra2;
PRINT delCompra3;
DROP SEQUENCE seq_fatura_ordem;
