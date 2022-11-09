--RIAs não implementadas: 2,3,5,6,7,10,19,20--
DROP TABLE Oferece;
DROP TABLE Fornece;
DROP TABLE Fatura;
DROP TABLE Cliente;
DROP TABLE Existe;
DROP TABLE Ano;
DROP TABLE Loja;
DROP TABLE Fornecedor;
DROP TABLE PessoaColetiva;
DROP TABLE Produto;
--
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy-mm-dd'; 
--alters date format because session might have a different one--
--
CREATE TABLE Produto (
    EAN13 NUMBER(13),
    Nome VARCHAR(40) NOT NULL,
    Peso NUMBER(3,1) NOT NULL,
    Largura NUMBER(10) NOT NULL,
    Altura NUMBER(10) NOT NULL,
    Profundidade NUMBER(10) NOT NULL,
    Categoria VARCHAR(10) NOT NULL,
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
        CHECK (Categoria IN ('comida','roupa','beleza','animais'))
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
    Nome VARCHAR(40) NOT NULL,
    Gênero VARCHAR(10) NOT NULL,
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
    NIPC NUMBER(9),
    Ano NUMBER(4),
    Número_Sequencial NUMBER(9),
    NIF NUMBER(9) NOT NULL,
    Data_1 DATE NOT NULL,
    --
    CONSTRAINT pk_Fatura
        PRIMARY KEY (NIPC,Ano,Número_Sequencial),
    --
    CONSTRAINT fk_Fatura_Existe
        FOREIGN KEY (NIPC,Ano) REFERENCES Existe (NIPC,Ano) ON DELETE CASCADE,
    --
    CONSTRAINT fk_Fatura_Cliente
        FOREIGN KEY (NIF) REFERENCES Cliente (NIF),
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
        FOREIGN KEY (NIPC_Loja,Ano) REFERENCES Existe (NIPC,Ano) ON DELETE CASCADE
);
--
CREATE TABLE Oferece (
    NIPC_Fornecedor NUMBER(9),
    Ano NUMBER(4),
    NIPC_Loja NUMBER(9),
    EAN13 NUMBER(13),
    Preco NUMBER(6,2) NOT NULL,
    Dia_de_Semana_de_Fornecimento VARCHAR(20) NOT NULL,
    Unidades_por_Semana NUMBER(4) NOT NULL,
    --
    CONSTRAINT pk_Oferece
        PRIMARY KEY (NIPC_Fornecedor,Ano,NIPC_Loja,EAN13),
    --
    CONSTRAINT fk_Oferece_Fornece
        FOREIGN KEY (NIPC_Fornecedor,Ano,NIPC_Loja) REFERENCES Fornece (NIPC_Fornecedor,Ano,NIPC_Loja) ON DELETE CASCADE,
    --
    CONSTRAINT fk_Oferece_Produto
        FOREIGN KEY (EAN13) REFERENCES Produto (EAN13),
    --
    CONSTRAINT ck_Oferece_Positivo--RIA14
        CHECK (Preco > 0 AND Unidades_por_Semana > 0),
    --
    CONSTRAINT ck_Oferece_Dia_de_Semana--RIA15
        CHECK (Dia_de_Semana_de_Fornecimento IN 
        ('segunda-feira','terça-feira','quarta-feira','quinta-feira','sexta-feira','sábado','domingo'))
);
--
INSERT INTO Produto (EAN13, Nome, Peso, Largura, Altura, Profundidade, Categoria)
    VALUES (1111111111111, 'Banana', 2, 1, 1, 1, 'comida');
--
INSERT INTO Produto (EAN13, Nome, Peso, Largura, Altura, Profundidade, Categoria)
    VALUES (2222222222222, 'Batom', 5, 5, 4, 2, 'beleza');
--
INSERT INTO Produto (EAN13, Nome, Peso, Largura, Altura, Profundidade, Categoria)
    VALUES (3333333333333, 'Camisa', 5, 40, 60, 3, 'roupa');
--
INSERT INTO Produto (EAN13, Nome, Peso, Largura, Altura, Profundidade, Categoria)
    VALUES (4444444444444, 'Gato', 8, 20, 30, 15, 'animais');
--
INSERT INTO PessoaColetiva (NIPC, Telefone, Nome)
    VALUES (111111111, 911222333, 'LIDL');    
--
INSERT INTO PessoaColetiva (NIPC, Telefone, Nome)
    VALUES (222222222, 922333444, 'Continente');
--
INSERT INTO PessoaColetiva (NIPC, Telefone, Nome)
    VALUES (333333333, 933444555, 'Fornecedor.co');
--
INSERT INTO PessoaColetiva (NIPC, Telefone, Nome)
    VALUES (444444444, 944555666, 'For.Inc');   
--
INSERT INTO Fornecedor (NIPC)
    VALUES (333333333);
--
INSERT INTO Fornecedor (NIPC)
    VALUES (444444444);  
--
INSERT INTO Loja (NIPC)
    VALUES (111111111);
--
INSERT INTO Loja (NIPC)
    VALUES (222222222);  
--
INSERT INTO Ano (Ano)
    VALUES (2022);  
--
INSERT INTO Ano (Ano)
    VALUES (1987); 
--
INSERT INTO Ano (Ano)
    VALUES (2016); 
--
INSERT INTO Ano (Ano)
    VALUES (2021);
--
INSERT INTO Ano (Ano)
    VALUES (2010);  
--
INSERT INTO Ano (Ano)
    VALUES (2000);
--
INSERT INTO Ano (Ano)
    VALUES (1980); 
--
INSERT INTO Existe (NIPC, Ano)
    VALUES (111111111, 2021);
--
INSERT INTO Existe (NIPC, Ano)
    VALUES (111111111, 2022);
--
INSERT INTO Existe (NIPC, Ano)
    VALUES (222222222, 2016);
--
INSERT INTO Existe (NIPC, Ano)
    VALUES (222222222, 2022);   
--
INSERT INTO Cliente (NIF, Nome, Gênero, Ano_Registo, Ano_Nascimento)
    VALUES (123456789, 'Maria', 'feminino', 2022, 2000);
--
INSERT INTO Cliente (NIF, Nome, Gênero, Ano_Registo, Ano_Nascimento)
    VALUES (234567891, 'André', 'masculino', 2010, 1980);
--
INSERT INTO Fatura (NIPC, Ano, Número_Sequencial, NIF, Data_1)
    VALUES (111111111, 2022, 1, 123456789, '2022-01-27');
--
INSERT INTO Fatura (NIPC, Ano, Número_Sequencial, NIF, Data_1)
    VALUES (222222222, 2022, 1, 234567891, '2022-10-05');  
--
INSERT INTO Fornece (NIPC_Fornecedor, Ano, NIPC_Loja)
    VALUES (333333333, 2022, 111111111);
--
INSERT INTO Fornece (NIPC_Fornecedor, Ano, NIPC_Loja)
    VALUES (444444444, 2022, 222222222);  
--
INSERT INTO Oferece (NIPC_Fornecedor, Ano, NIPC_Loja, EAN13, Preco, Dia_de_Semana_de_Fornecimento, Unidades_por_Semana)
    VALUES (333333333, 2022, 111111111, 4444444444444, 2.99, 'terça-feira', 100);
--
INSERT INTO Oferece (NIPC_Fornecedor, Ano, NIPC_Loja, EAN13, Preco, Dia_de_Semana_de_Fornecimento, Unidades_por_Semana)
    VALUES (444444444, 2022, 222222222, 1111111111111, 0.99, 'domingo', 500);
