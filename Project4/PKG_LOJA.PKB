CREATE OR REPLACE PACKAGE BODY PKG_LOJA IS

    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE, 
        nome_in IN cliente.nome%TYPE, 
        genero_in IN cliente.genero%TYPE, 
        nascimento_in IN cliente.nascimento%TYPE, 
        localidade_in IN cliente.localidade%TYPE);  

    IS
    BEGIN
        INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
            VALUES(nif_in, nome_in, genero_in, nascimento_in, localidade_in);

    PROCEDURE regista_produto(
        ean13_in IN produto.ean13%TYPE, 
        nome_in IN produto.nome%TYPE, 
        categoria_in IN produto.categoria%TYPE, 
        preco_in IN produto.preco%TYPE, 
        stock_in IN produto.stock%TYPE);

    IS
    BEGIN
        INSERT INTO produto (ean13, nome, categoria, preco, stock)
            VALUES(ean13_in, nome_in, categoria_in, preco_in, stock_in);

END PKG_LOJA;
/
