-------------------
-- CRIAÇÃO DO BD --
-------------------

CREATE TABLE FEDERACAO (
    NOME VARCHAR(30),
    ID_FED INT,
    CONSTRAINT PK_FEDERACAO PRIMARY KEY (ID_FED)
);

CREATE TABLE PRESIDENTE_DA_FEDERACAO (
    NOME VARCHAR(30),
    ID INT,
    ID_FED INT,
    CONSTRAINT PK_PRESIDENTE_DA_FEDERACAO PRIMARY KEY (ID),
    CONSTRAINT FK_PRESIDENTE_FEDERACAO FOREIGN KEY (ID_FED) REFERENCES FEDERACAO(ID_FED)
);

CREATE TABLE ESTADIO (
    NOME VARCHAR(30),
    COD_ESTADIO INT,
    CAPACIDADE INT,
    END_PAIS VARCHAR(30),
    END_CIDADE VARCHAR(30),
    END_CEP INT,
    END_NUMERO INT,
    CONSTRAINT PK_ESTADIO PRIMARY KEY (COD_ESTADIO)
);

CREATE TABLE COMPETICAO (
    NOME VARCHAR(30),
    ID_ARTIFICIAL INT,
    ID_FED INT,
    TEMPORADA INT, 
    CONSTRAINT PK_COMPETICAO PRIMARY KEY (ID_ARTIFICIAL, ID_FED),
    CONSTRAINT FK_COMPETICAO FOREIGN KEY (ID_FED) REFERENCES FEDERACAO(ID_FED)
);

CREATE TABLE CLUBE(
    NOME VARCHAR(30),
    CODIGO INT,
    MASCOTE VARCHAR(30),
    SEDE VARCHAR(30),
    CONSTRAINT PK_CLUBE PRIMARY KEY (CODIGO)
);

CREATE TABLE JOGO(
   CODIGO INT,
   DATA_ DATE,
   FASE VARCHAR(30),
   ID_ARTIFICIAL INT,
   ID_FED INT,
   CODIGO_VISITANTE INT NOT NULL,
   CODIGO_MANDANTE INT NOT NULL,
   CONSTRAINT PK_JOGO PRIMARY KEY (CODIGO),
   CONSTRAINT FK_JOGO_VISITANTE FOREIGN KEY (CODIGO_VISITANTE) REFERENCES CLUBE(CODIGO),
   CONSTRAINT  FK_JOGO_MANDANTE FOREIGN KEY (CODIGO_MANDANTE) REFERENCES CLUBE(CODIGO),
   CONSTRAINT FK_JOGO_COMPETICAO FOREIGN KEY (ID_ARTIFICIAL, ID_FED) REFERENCES COMPETICAO(ID_ARTIFICIAL, ID_FED)
);

CREATE TABLE ARBITRO(
    NOME VARCHAR(30),
    CODIGO INT,
    DT_NASCIMENTO DATE,
    NACIONALIDADE VARCHAR(30),
    CONSTRAINT PK_ARBITRO PRIMARY KEY (CODIGO)
);

CREATE TABLE EMPRESA(
    NOME VARCHAR(30),
    CNPJ INT,
    CONSTRAINT PK_EMPRESA PRIMARY KEY (CNPJ)
);

CREATE TABLE FUNCIONARIO(
    NOME VARCHAR(30),
    ID_FUNC INT,
    SALARIO INT,
    DT_NASCIMENTO DATE,
    NACIONALIDADE VARCHAR(30),
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (ID_FUNC)
);

CREATE TABLE JOGADOR(
    ID_JOGADOR INT,
    CONSTRAINT PK_JOGADOR PRIMARY KEY (ID_JOGADOR),
    CONSTRAINT FK_JOGADOR FOREIGN KEY (ID_JOGADOR) REFERENCES FUNCIONARIO(ID_FUNC)
);

CREATE TABLE TROFEU(
    NOME VARCHAR(30),
    VALOR INT,
    CONSTARINT PK_TROFEU PRIMARY KEY (NOME)
);

CREATE TABLE PARTICIPA(
    CODIGO INT,
    ID_ARTIFICIAL INT,
    ID_FED INT,
    NOME_TROFEU VARCHAR(30),
    COLOCACAO VARCHAR(30),
    CONSTRAINT PK_PARTICIPA PRIMARY KEY(CODIGO, ID_ARTIFICIAL, ID_FED, NOME_TROFEU),
    CONSTRAINT FK_PARTICIPA_CLUBE FOREIGN KEY(CODIGO) REFERENCES CLUBE(CODIGO),
    CONSTRAINT FK_PARTICIPA_COMPETICAO FOREIGN KEY(ID_ARTIFICIAL, ID_FED) REFERENCES COMPETICAO(ID_ARTIFICIAL, ID_FED),
    CONSTRAINT FK_PARTICIPA_TROFEU FOREIGN KEY(NOME_TROFEU) REFERENCES TROFEU(NOME)
);

CREATE TABLE GARANTE_VAGA(
    ID_ARTIFICIAL_MAIOR INT,
    ID_FED_MAIOR INT,
    ID_ARTIFICIAL_MENOR INT,
    ID_FED_MENOR INT,
    CONSTRAINT PK_GARANTE_VAGA PRIMARY KEY(ID_ARTIFICIAL_MAIOR, ID_FED_MAIOR, ID_ARTIFICIAL_MENOR, ID_FED_MENOR),
    CONSTRAINT FK_GARANTE_VAGA1 FOREIGN KEY(ID_ARTIFICIAL_MAIOR, ID_FED_MAIOR) REFERENCES COMPETICAO(ID_ARTIFICIAL, ID_FED),
    CONSTRAINT FK_GARANTE_VAGA2 FOREIGN KEY(ID_ARTIFICIAL_MENOR, ID_FED_MENOR) REFERENCES COMPETICAO(ID_ARTIFICIAL, ID_FED)
);

CREATE TABLE FAZ_PARTE(
    CODIGO_ARBITRO INT,
    ID_FED INT,
    CONSTRAINT PK_FAZ_PARTE PRIMARY KEY(CODIGO_ARBITRO, ID_FED),
    CONSTRAINT FK_FAZ_PARTE_ARBITRO FOREIGN KEY(CODIGO_ARBITRO) REFERENCES ARBITRO(CODIGO),
    CONSTRAINT FK_FAZ_PARTE_FED FOREIGN KEY(ID_FED) REFERENCES FEDERACAO(ID_FED) 
);

CREATE TABLE PAT_CLUBE(
    CODIGO_CLUBE INT, 
    CNPJ_EMPRESA INT,
    DT_CONTRATO DATE,
    VALOR INT,
    DURACAO INT,
    CONSTRAINT PK_PAT_CLUBE PRIMARY KEY(CODIGO_CLUBE, CNPJ_EMPRESA, DT_CONTRATO),
    CONSTRAINT FK_PAT_CLUBE_COD FOREIGN KEY(CODIGO_CLUBE) REFERENCES CLUBE(CODIGO),
    CONSTRAINT FK_PAT_CLUBE_EMP FOREIGN KEY(CNPJ_EMPRESA) REFERENCES EMPRESA(CNPJ)
);

CREATE TABLE PAT_COMP(
    ID_COMP INT,
    ID_FED INT,
    CNPJ_EMPRESA INT,
    DT_CONTRATO DATE,
    VALOR INT,
    DURACAO INT,
    CONSTRAINT PK_PAT_COMP PRIMARY KEY(ID_COMP, ID_FED, CNPJ_EMPRESA, DT_CONTRATO),
    CONSTRAINT FK_PAT_COMP_COMP FOREIGN KEY(ID_COMP, ID_FED) REFERENCES COMPETICAO(ID_ARTIFICIAL, ID_FED),
    CONSTRAINT FK_PAT_COMP_EMPRESA FOREIGN KEY(CNPJ_EMPRESA) REFERENCES EMPRESA(CNPJ)
);

CREATE TABLE LIGADO(
    ID_FUNC INT,
    CODIGO_CLUBE INT,
    TEMPORADA INT,
    FUNCAO VARCHAR(30),
    CONSTRAINT PK_LIGADO PRIMARY KEY(ID_FUNC, CODIGO_CLUBE, TEMPORADA, FUNCAO),
    CONSTRAINT FK_LIGADO_FUNC FOREIGN KEY(ID_FUNC) REFERENCES FUNCIONARIO(ID_FUNC),
    CONSTRAINT FK_LIGADO_CLUBE FOREIGN KEY(CODIGO_CLUBE) REFERENCES CLUBE(CODIGO)

);

CREATE TABLE JOGADOR_PARTICIPA(
    ID_FUNC INT,
    CODIGO_JOGO INT,
    N_GOLS INT,
    N_ASSIST INT,
    POSICAO VARCHAR(30),
    CONSTRAINT PK_JOGADOR_JOGA PRIMARY KEY(ID_FUNC, CODIGO_JOGO),
    CONSTRAINT FK_PARTICIPA_FUNC FOREIGN KEY(ID_FUNC) REFERENCES FUNCIONARIO(ID_FUNC),
    CONSTRAINT FK_PARTICIPA_CODIGO FOREIGN KEY(CODIGO_JOGO) REFERENCES JOGO(CODIGO)
);

CREATE TABLE CARTOES(
    ID_FUNC INT, 
    COD_JOGO INT,
    COR VARCHAR(50),
    MINUTO TIMESTAMP,
    CONSTRAINT PK_CARTOES PRIMARY KEY(ID_FUNC, COD_JOGO, COR, MINUTO),
    CONSTRAINT FK_CARTOES_FUNC FOREIGN KEY(ID_FUNC, COD_JOGO) REFERENCES JOGADOR_PARTICIPA(ID_FUNC, CODIGO_JOGO)
);

CREATE TABLE TEM(
    COD_ARBITRO INT,
    COD_JOGO INT,
    FUNCAO_ARBITRO VARCHAR(30),
    PLACAR VARCHAR(30),
    COD_ESTADIO INT,
    CONSTRAINT PK_TEM PRIMARY KEY(COD_ARBITRO, COD_JOGO),
    CONSTRAINT FK_TEM_ARBITRO FOREIGN KEY(COD_ARBITRO) REFERENCES ARBITRO(CODIGO),
    CONSTRAINT FK_TEM_JOGO FOREIGN KEY(COD_JOGO) REFERENCES JOGO(CODIGO),
    CONSTRAINT FK_TEM_ESTADIO FOREIGN KEY(COD_ESTADIO) REFERENCES ESTADIO(COD_ESTADIO) 
);
