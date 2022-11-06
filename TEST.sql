CREATE TABLE Produto (
    EAN13 NUMBER(13),
    Nome VARCHAR(40),
    Peso NUMBER(3,1),
    Largura NUMBER(10),
    Altura NUMBER(10),
    Profundidade NUMBER(10),
    Categoria VARCHAR(10),

    CONSTRAINT pk_Produto
        PRIMARY KEY(EAN13),

    CONSTRAINT ck_Produto_EAN13
        CHECK (EAN13 > 0), 
        CHECK (LENGTH(EAN13) = 13)   
);
--
CREATE TABLE PessoaColetiva (
    NIPC NUMBER(9),
    Telefone NUMBER(9) CONSTRAINT nn_PessoaColetiva_Telefone NOT NULL,
    Nome VARCHAR(40),

    CONSTRAINT pk_PessoaColetiva
        PRIMARY KEY (NIPC),

    CONSTRAINT ck_PessoaColetiva_NIPC
        CHECK (NIPC > 0),
        CHECK (LENGTH(NIPC) = 9),

    CONSTRAINT ck_PessoaColetiva_Telefone
        CHECK (Telefone > 0),
        CHECK (LENGTH(Telefone) = 9)    
);
--
CREATE TABLE Fornecedor (
    NIPC NUMBER(9),

    CONSTRAINT pk_Fornecedor
        PRIMARY KEY (NIPC),

    CONSTRAINT fk_Fornecedor
        FOREIGN KEY (NIPC) REFERENCES PessoaColetiva (NIPC) ON DELETE CASCADE   
);
--
CREATE TABLE Loja (
    NIPC NUMBER(9),

    CONSTRAINT pk_Loja
        PRIMARY KEY (NIPC),

    CONSTRAINT fk_Loja
        FOREIGN KEY (NIPC) REFERENCES PessoaColetiva (NIPC) ON DELETE CASCADE   
);
--
CREATE TABLE Ano (
    Ano NUMBER(4),

    CONSTRAINT pk_Ano
        PRIMARY KEY (Ano),

    CONSTRAINT ck_Ano_Ano
        CHECK (Ano >= 1970)
);
--
CREATE TABLE Existe(
    NIPC NUMBER(9),
    Ano NUMBER(4),

    CONSTRAINT pk_Existe
        PRIMARY KEY (NIPC,Ano),

    CONSTRAINT fk_Existe1
        FOREIGN KEY (NIPC) REFERENCES Loja (NIPC),

    CONSTRAINT fk_Existe2
        FOREIGN KEY (Ano) REFERENCES Ano (Ano)  
);
--
CREATE TABLE Cliente (
    NIF NUMBER(9),
    Nome VARCHAR(40),
    Gênero VARCHAR(10),
    Ano_Registo NUMBER(4),
    Ano_Nascimento NUMBER(4),

    CONSTRAINT pk_Cliente
        PRIMARY KEY (NIF),

    CONSTRAINT fk_Cliente_Ano_Registo
        FOREIGN KEY (Ano_Registo) REFERENCES Ano (Ano),

    CONSTRAINT fk_Cliente_Ano_Nascimento
        FOREIGN KEY (Ano_Nascimento) REFERENCES Ano (Ano),

    CONSTRAINT ck_Cliente_NIF
        CHECK (NIF > 0),
        CHECK (LENGTH(NIF) = 9),

    CONSTRAINT ck_Cliente_Gênero
        CHECK (Gênero = 'masculino' OR Gênero = 'feminino'),

    CONSTRAINT ck_Cliente_Idade
        CHECK (Ano_Registo - Ano_Nascimento >= 18)      
);