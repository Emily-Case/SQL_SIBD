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
            UPDATE produto SET stock = (stock_atual - unidades_in) WHERE (ean13 = produto_in);
            RETURN seq_fatura_ordem.CURRVAL;

        ELSE
            INSERT INTO linhafatura (fatura, produto, unidades)
                VALUES(fatura_in, produto_in, unidades_in);
            UPDATE produto SET stock = (stock_atual - unidades_in) WHERE (ean13 = produto_in);
            RETURN fatura_in;

        END IF;
        CLOSE cursor_produto;
    
    END regista_compra;

    FUNCTION remove_compra(
        fatura_in IN fatura.numero%TYPE,
        produto_in IN produto.ean13%TYPE := NULL)
        RETURN NUMBER

    IS
        CURSOR cursor_linhafatura IS SELECT produto FROM linhafatura WHERE fatura = fatura_in;
        TYPE tabela_local_linhafatura IS TABLE OF cursor_linhafatura%ROWTYPE;
        CURSOR cursor_produto IS SELECT stock FROM produto WHERE (produto.ean13 = produto_in);
        CURSOR cursor_linhafatura2 IS SELECT unidades FROM linhafatura WHERE fatura = fatura_in AND produto = produto_in;

        produtos tabela_local_linhafatura;
        stock_atual NUMBER;
        stock_adicionar NUMBER;

    BEGIN

        OPEN cursor_linhafatura;
        OPEN cursor_linhafatura2;
        OPEN cursor_produto;
        FETCH cursor_linhafatura BULK COLLECT INTO produtos;
        FETCH cursor_linhafatura2 INTO stock_adicionar;
        FETCH cursor_produto INTO stock_atual;
        CLOSE cursor_linhafatura;
        CLOSE cursor_linhafatura2;
        CLOSE cursor_produto;

        IF (produtos.COUNT = 0) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Fatura a remover produtos de não existe.');

        ELSIF (produto_in IS NULL) THEN
            --FOR x IN produtos.FIRST .. produtos.LAST LOOP
                --DELETE FROM linhafatura WHERE (fatura = fatura_in) AND (produto = produtos(x));
            --END LOOP;
            DELETE FROM fatura WHERE (numero = fatura_in);
            RETURN 0;

        ELSIF (produtos.COUNT = 1) THEN
            DELETE FROM linhafatura WHERE (fatura = fatura_in) AND (produto = produto_in);
            DELETE FROM fatura WHERE (numero = fatura_in);
            UPDATE produto SET stock = (stock_atual + stock_adicionar) WHERE (ean13 = produto_in);
            RETURN 0;

        ELSE
            DELETE FROM linhafatura WHERE (fatura = fatura_in) AND (produto = produto_in);
            UPDATE produto SET stock = (stock_atual + stock_adicionar) WHERE (ean13 = produto_in);
            RETURN (produtos.COUNT - 1);

        END IF;

    END remove_compra;

END PKG_LOJA;
/
