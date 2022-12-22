CREATE OR REPLACE PACKAGE PKG_LOJA IS
-- ----------------------------------------------------------------------------
    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE, 
        nome_in IN cliente.nome%TYPE, 
        genero_in IN cliente.genero%TYPE, 
        nascimento_in IN cliente.nascimento%TYPE, 
        localidade_in IN cliente.localidade%TYPE);
-- ----------------------------------------------------------------------------
    PROCEDURE regista_produto(
        ean13_in IN produto.ean13%TYPE, 
        nome_in IN produto.nome%TYPE, 
        categoria_in IN produto.categoria%TYPE, 
        preco_in IN produto.preco%TYPE, 
        stock_in IN produto.stock%TYPE);
-- ----------------------------------------------------------------------------
    FUNCTION regista_compra(
        cliente_in IN cliente.nif%TYPE,
        produto_in IN produto.ean13%TYPE, 
        unidades_in IN NUMBER, 
        fatura_in IN fatura.numero%TYPE := NULL)
        RETURN NUMBER;
-- ----------------------------------------------------------------------------
    FUNCTION remove_compra(
        fatura_in IN fatura.numero%TYPE,
        produto_in IN produto.ean13%TYPE := NULL)
        RETURN NUMBER;
-- ----------------------------------------------------------------------------
    PROCEDURE remove_produto(
        ean13_in IN produto.ean13%TYPE);
-- ----------------------------------------------------------------------------
    PROCEDURE remove_cliente(
        nif_in IN cliente.nif%TYPE);
-- ----------------------------------------------------------------------------
    --FUNCTION lista_produtos(
        --categoria_in IN produto.categoria%TYPE)
        --RETURN SYS_REFCURSOR;
-- ----------------------------------------------------------------------------
END PKG_LOJA;
/
-- ----------------------------------------------------------------------------
