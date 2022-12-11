CREATE OR REPLACE PACKAGE PKG_LOJA IS

    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE, 
        nome_in IN cliente.nome%TYPE, 
        genero_in IN cliente.genero%TYPE, 
        nascimento_in IN cliente.nascimento%TYPE, 
        localidade_in IN cliente.localidade%TYPE);

    PROCEDURE regista_produto(
        ean13_in IN produto.ean13%TYPE, 
        nome_in IN produto.nome%TYPE, 
        categoria_in IN produto.categoria%TYPE, 
        preco_in IN produto.preco%TYPE, 
        stock_in IN produto.stock%TYPE);

END PKG_LOJA;
/        
