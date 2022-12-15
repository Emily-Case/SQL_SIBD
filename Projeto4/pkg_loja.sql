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
VARIABLE numFatura1a NUMBER;
VARIABLE numFatura1b NUMBER;
VARIABLE numFatura1c NUMBER;
VARIABLE numFatura1d NUMBER;
VARIABLE numFatura1e NUMBER;
VARIABLE numFatura1f NUMBER;
VARIABLE numFatura1g NUMBER;
-- ----------------------------------------------------------------------------
VARIABLE numFatura2 NUMBER;
VARIABLE numFatura2a NUMBER;
-- ----------------------------------------------------------------------------
VARIABLE delCompra1 NUMBER;
VARIABLE delCompra1a NUMBER;
VARIABLE delCompra1b NUMBER;
-- ----------------------------------------------------------------------------
VARIABLE delCompra2 NUMBER;
-- ----------------------------------------------------------------------------
BEGIN
-- Inserir os produtos que a loja disponibliza
-- Categoria: Comida
pkg_loja.regista_produto(1111111111111,'Morango','Comida',2.99,1000);
pkg_loja.regista_produto(2222222222222,'Massa','Comida',0.99,5000);
pkg_loja.regista_produto(3333333333333,'Carne','Comida',4.99,500);
pkg_loja.regista_produto(4444444444444,'Queijo','Comida',3.99,1000);
pkg_loja.regista_produto(5555555555555,'Baguete','Comida',0.50,2000);
-- Categoria: Roupa
pkg_loja.regista_produto(1222222222222,'T-Shirt','Roupa',9.99,2000);
pkg_loja.regista_produto(2333333333333,'Meias','Roupa',1.99,100);
pkg_loja.regista_produto(3444444444444,'Jeans','Roupa',12.00,1200);
pkg_loja.regista_produto(4555555555555,'Sapatilhas','Roupa',19.99,300);
pkg_loja.regista_produto(5666666666666,'Camisa','Roupa',7.50,3500);
-- Categoria: Beleza
pkg_loja.regista_produto(1333333333333,'Batom','Beleza',4.99,450);
pkg_loja.regista_produto(2444444444444,'Verniz','Beleza',2.99,700);
pkg_loja.regista_produto(3555555555555,'Base','Beleza',3.99,2250);
pkg_loja.regista_produto(4666666666666,'Perfume','Beleza',20.00,750);
pkg_loja.regista_produto(5777777777777,'Eyeliner','Beleza',1.50,3250);
-- Categoria: Animais
pkg_loja.regista_produto(1444444444444,'Comida de Gato','Animais',19.99,750);
pkg_loja.regista_produto(2555555555555,'Coleira','Animais',4.99,600);
pkg_loja.regista_produto(3666666666666,'Pente','Animais',8.00,200);
pkg_loja.regista_produto(4777777777777,'Aquario','Animais',199.99,50);
pkg_loja.regista_produto(5888888888888,'Comida de Peixe','Animais',2.99,500);
-- ----------------------------------------------------------------------------
-- Inserir os clientes
pkg_loja.regista_cliente(111111111,'Joaquim','M',2000,'Lisboa');
pkg_loja.regista_cliente(222222222,'Beatriz','F',2003,'Lisboa');
pkg_loja.regista_cliente(333333333,'Miguel','M',1987,'Porto');
pkg_loja.regista_cliente(444444444,'Sara','F',2001,'Coimbra');
pkg_loja.regista_cliente(555555555,'Diogo','M',1992,'Beja');
-- ----------------------------------------------------------------------------
-- O cliente 111111111 realiza uma compra na loja
:numFatura1 := pkg_loja.regista_compra(111111111,1111111111111,3);
:numFatura1a := pkg_loja.regista_compra(111111111,1222222222222,2,:numFatura1);
:numFatura1b := pkg_loja.regista_compra(111111111,3333333333333,1,:numFatura1);
:numFatura1c := pkg_loja.regista_compra(111111111,4444444444444,5,:numFatura1);
:numFatura1d := pkg_loja.regista_compra(111111111,5555555555555,10,:numFatura1);
:numFatura1e := pkg_loja.regista_compra(111111111,1333333333333,1,:numFatura1);
:numFatura1f := pkg_loja.regista_compra(111111111,2444444444444,2,:numFatura1);
:numFatura1g := pkg_loja.regista_compra(111111111,1444444444444,1,:numFatura1);
-- ----------------------------------------------------------------------------
-- O cliente 222222222 realiza uma compra na loja
:numFatura2 := pkg_loja.regista_compra(222222222,2222222222222,20);
:numFatura2a := pkg_loja.regista_compra(222222222,3333333333333,100,:numFatura2);
-- ----------------------------------------------------------------------------
-- O cliente 111111111 realiza uma devolução dos produtos 3333333333333, 1333333333333 e 1222222222222
:delCompra1 := pkg_loja.remove_compra(:numFatura1,3333333333333);
:delCompra1a := pkg_loja.remove_compra(:numFatura1,1333333333333);
:delCompra1b := pkg_loja.remove_compra(:numFatura1,1222222222222);
-- O cliente 222222222 remove todas as compras que efetuou
:delCompra2 := pkg_loja.remove_compra(:numFatura2);
-- ----------------------------------------------------------------------------
END;
/
-- ----------------------------------------------------------------------------
SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM fatura;
SELECT * FROM linhafatura;
PRINT numFatura1;
PRINT numFatura2;
PRINT delCompra1b;
PRINT delCompra2;
-- ----------------------------------------------------------------------------
