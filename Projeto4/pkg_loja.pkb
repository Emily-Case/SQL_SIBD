CREATE OR REPLACE PACKAGE BODY PKG_LOJA IS

    PROCEDURE regista_cliente(
        nif_in IN cliente.nif%TYPE, 
        nome_in IN cliente.nome%TYPE, 
        genero_in IN cliente.genero%TYPE, 
        nascimento_in IN cliente.nascimento%TYPE, 
        localidade_in IN cliente.localidade%TYPE)

    IS
    BEGIN
        INSERT INTO cliente (nif, nome, genero, nascimento, localidade)
            VALUES(nif_in, nome_in, genero_in, nascimento_in, localidade_in);
    END regista_cliente;

    PROCEDURE regista_produto(
        ean13_in IN produto.ean13%TYPE, 
        nome_in IN produto.nome%TYPE, 
        categoria_in IN produto.categoria%TYPE, 
        preco_in IN produto.preco%TYPE, 
        stock_in IN produto.stock%TYPE)

    IS
    BEGIN
        INSERT INTO produto (ean13, nome, categoria, preco, stock)
            VALUES(ean13_in, nome_in, categoria_in, preco_in, stock_in);
    END regista_produto;

    FUNCTION regista_compra(
        cliente_in IN cliente.nif%TYPE, 
        produto_in IN produto.ean13%TYPE, 
        unidades_in IN NUMBER, 
        fatura_in IN fatura.numero%TYPE := NULL)
        RETURN NUMBER

    IS
        CURSOR cursor_produto IS SELECT stock FROM produto WHERE (produto_in = produto.ean13);
        stock_atual NUMBER;
        fatura_num NUMBER;

    BEGIN

        OPEN cursor_produto;
        FETCH cursor_produto INTO stock_atual;

        IF(unidades_in > stock_atual) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Não existe stock suficiente para efetuar a compra.');

        ELSIF (fatura_in IS NULL) THEN
            INSERT INTO fatura (numero, data, cliente)
                VALUES(seq_fatura_ordem.NEXTVAL, SYSDATE(), cliente_in);
            INSERT INTO linhafatura (fatura, produto, unidades)
                VALUES(seq_fatura_ordem.CURRVAL, produto_in, unidades_in);
            RETURN seq_fatura_ordem.CURRVAL;

        ELSE
            INSERT INTO linhafatura (fatura, produto, unidades)
                VALUES(fatura_in, produto_in, unidades_in);
            RETURN fatura_in;

        END IF;
        CLOSE cursor_produto;
    
    END regista_compra;

END PKG_LOJA;
/
