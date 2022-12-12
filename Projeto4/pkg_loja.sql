@tabelas.sql
@pkg_loja.pks
@pkg_loja.pkb

BEGIN
pkg_loja.regista_cliente(111111111,'Joaquim','M',2003,'Lisboa');
pkg_loja.regista_produto(1234567891234,'Maça','Comida',2.99,1000);
END;
/
SELECT * FROM cliente;
SELECT * FROM produto;
