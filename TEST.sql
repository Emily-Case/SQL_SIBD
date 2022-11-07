--RIAs não implementadas: 2,3,5,6,7,19,20--
--RIAs que (maybe) podemos implementar: 10--

CREATE TABLE Produto (
    EAN13 NUMBER(13),
    Nome VARCHAR(40),
    Peso NUMBER(3,1),
    Largura NUMBER(10),
    Altura NUMBER(10),
    Profundidade NUMBER(10),
    Categoria VARCHAR(10),
    --
    CONSTRAINT pk_Produto
        PRIMARY KEY(EAN13),
    --
    CONSTRAINT ck_Produto_EAN13--RIA11
        CHECK (EAN13 > 0), 
        CHECK (LENGTH(EAN13) = 13),
    --
    CONSTRAINT ck_Produto_Positivos--RIA12
        CHECK (Peso > 0 AND Largura > 0 AND Altura > 0 AND Profundidade > 0),
    --
    CONSTRAINT ck_Produto_Categoria--RIA13
        CHECK (Categoria = 'comida' OR Categoria = 'roupa' OR Categoria = 'beleza' OR Categoria = 'animais')
);
--
CREATE TABLE PessoaColetiva (
    NIPC NUMBER(9),
    Telefone NUMBER(9) CONSTRAINT nn_PessoaColetiva_Telefone NOT NULL,
    Nome VARCHAR(40) CONSTRAINT un_nn_PessoaColetiva_Nome UNIQUE NOT NULL,--RIA9
    --
    CONSTRAINT pk_PessoaColetiva
        PRIMARY KEY (NIPC),
    --
    CONSTRAINT ck_PessoaColetiva_NIPC--RIA8
        CHECK (NIPC > 0),
        CHECK (LENGTH(NIPC) = 9),
    --
    CONSTRAINT ck_PessoaColetiva_Telefone--RIA8
        CHECK (Telefone > 0),
        CHECK (LENGTH(Telefone) = 9)    
);
--
CREATE TABLE Fornecedor (
    NIPC NUMBER(9),
    --
    CONSTRAINT pk_Fornecedor
        PRIMARY KEY (NIPC),
    --
    CONSTRAINT fk_Fornecedor
        FOREIGN KEY (NIPC) REFERENCES PessoaColetiva (NIPC) ON DELETE CASCADE   
);
--
CREATE TABLE Loja (
    NIPC NUMBER(9),
    --
    CONSTRAINT pk_Loja
        PRIMARY KEY (NIPC),
    --
    CONSTRAINT fk_Loja
        FOREIGN KEY (NIPC) REFERENCES PessoaColetiva (NIPC) ON DELETE CASCADE   
);
--
CREATE TABLE Ano (
    Ano NUMBER(4),
    --
    CONSTRAINT pk_Ano
        PRIMARY KEY (Ano),
    --
    CONSTRAINT ck_Ano_Ano
        CHECK (Ano >= 1970)--RIA4
);
--
CREATE TABLE Existe(
    NIPC NUMBER(9),
    Ano NUMBER(4),
    --
    CONSTRAINT pk_Existe
        PRIMARY KEY (NIPC,Ano),
    --
    CONSTRAINT fk_Existe1
        FOREIGN KEY (NIPC) REFERENCES Loja (NIPC),
    --
    CONSTRAINT fk_Existe2
        FOREIGN KEY (Ano) REFERENCES Ano (Ano)  
);
--
CREATE TABLE Cliente (
    NIF NUMBER(9),
    Nome VARCHAR(40),
    Gênero VARCHAR(10),
    Ano_Registo NUMBER(4) CONSTRAINT nn_Cliente_Ano_Registo NOT NULL,
    Ano_Nascimento NUMBER(4) CONSTRAINT nn_Cliente_Ano_Nascimento NOT NULL,
    --
    CONSTRAINT pk_Cliente
        PRIMARY KEY (NIF),
    --
    CONSTRAINT fk_Cliente_Ano_Registo
        FOREIGN KEY (Ano_Registo) REFERENCES Ano (Ano),
    --
    CONSTRAINT fk_Cliente_Ano_Nascimento
        FOREIGN KEY (Ano_Nascimento) REFERENCES Ano (Ano),
    --
    CONSTRAINT ck_Cliente_NIF--RIA16
        CHECK (NIF > 0),
        CHECK (LENGTH(NIF) = 9),
    --
    CONSTRAINT ck_Cliente_Gênero--RIA17
        CHECK (Gênero = 'masculino' OR Gênero = 'feminino'),
    --
    CONSTRAINT ck_Cliente_Idade
        CHECK (Ano_Registo - Ano_Nascimento >= 18)--RIA1
);
--
CREATE TABLE Fatura (
    NIF NUMBER(9),
    NIPC NUMBER(9),
    Ano NUMBER(4),
    Número_Sequencial NUMBER(9),
    Data DATE,
    --
    CONSTRAINT pk_Fatura
        PRIMARY KEY (NIF,NIPC,Ano,Número_Sequencial),
    --
    CONSTRAINT fk_Fatura_Existe
        FOREIGN KEY (NIPC,Ano) REFERENCES Existe (NIPC,Ano) ON DELETE CASCADE,
    --
    CONSTRAINT fk_Fatura_Cliente
        FOREIGN KEY (NIF) REFERENCES Cliente (NIF) ON DELETE NO ACTION,
    --
    CONSTRAINT ck_Fatura_Número_Sequencial--RIA18
        CHECK (Número_Sequencial >= 1)
);
--
CREATE TABLE Fornece (
    NIPC_Fornecedor NUMBER(9),
    Ano NUMBER(4),
    NIPC_Loja NUMBER(9),
    --
    CONSTRAINT pk_Fornece
        PRIMARY KEY (NIPC_Fornecedor,Ano,NIPC_Loja),
    --
    CONSTRAINT fk_Fornece_Fornecedor
        FOREIGN KEY (NIPC_Fornecedor) REFERENCES Fornecedor (NIPC),
    --
    CONSTRAINT fk_Fornece_Existe
        FOREIGN KEY (NIPC_Loja,Ano) REFERENCES Existe (NIPC,Ano)
);
--
CREATE TABLE Oferece (
    NIPC_Fornecedor NUMBER(9),
    Ano NUMBER(4),
    NIPC_Loja NUMBER(9),
    EAN13 NUMBER(13),
    Preço NUMBER(6,2),
    Dia_de_Semana_de_Fornecimento VARCHAR(20),
    Unidades_por_Semana NUMBER(4),
    --
    CONSTRAINT pk_Oferece
        PRIMARY KEY (NIPC_Fornecedor,Ano,NIPC_Loja,EAN13),
    --
    CONSTRAINT fk_Oferece_Fornece
        FOREIGN KEY (NIPC_Fornecedor,Ano,NIPC_Loja) REFERENCES Fornece (NIPC_Fornecedor,Ano,NIPC_Loja),
    --
    CONSTRAINT fk_Oferece_Produto
        FOREIGN KEY (EAN13) REFERENCES Produto (EAN13),
    --
    CONSTRAINT ck_Oferece_Positivo--RIA14
        CHECK (Preço > 0 AND Unidades_por_Semana > 0),
    --
    CONSTRAINT ck_Oferece_Dia_de_Semana--RIA15
        CHECK (Dia_de_Semana_de_Fornecimento = 'segunda-feira' 
        OR Dia_de_Semana_de_Fornecimento = 'terça-feira' 
        OR Dia_de_Semana_de_Fornecimento = 'quarta-feira' 
        OR Dia_de_Semana_de_Fornecimento = 'quinta-feira' 
        OR Dia_de_Semana_de_Fornecimento = 'sexta-feira' 
        OR Dia_de_Semana_de_Fornecimento = 'sábado' 
        OR Dia_de_Semana_de_Fornecimento = 'domingo')
);
