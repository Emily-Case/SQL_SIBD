@tabelas.sql
@pkg_loja.pks
@pkg_loja.pkb

BEGIN
pkg_loja.regista_cliente(111111111,'joaquim','F',2004,'rua do adeus');
pkg_loja.regista_produto(1234567891234,'veggies','Comida',2.99,1000);
END;
/
SELECT * FROM cliente;
SELECT * FROM produto;
