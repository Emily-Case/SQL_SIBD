-- SIBD 2022/2023   Etapa 4   Grupo 20
-- Inês Luz      fc57552 (TP13)
-- José Sá       fc58200 (TP11)
-- Marta Lorenço fc58249 (TP15)
-- Yichen Cao    fc58165 (TP11)
CREATE OR REPLACE PACKAGE PKG_LOJA IS
-- ----------------------------------------------------------------------------
-- As operações lançam exceções para sinalizar casos de erro.
-- Mensagens das Exceções:
--  -20001 - Não existe stock suficiente para efetuar a compra.
--  -20002 - Fatura a remover produtos de não existe.
--  -20003 - Produto a remover não existe.
--  -20004 - Cliente a remover não existe.
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
    FUNCTION lista_produtos(
        categoria_in IN produto.categoria%TYPE)
        RETURN SYS_REFCURSOR;
-- ----------------------------------------------------------------------------
END PKG_LOJA;
/
-- ----------------------------------------------------------------------------
