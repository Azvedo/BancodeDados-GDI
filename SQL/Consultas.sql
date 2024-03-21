-- CONSULTAS --
-------------------------------------------------------------------

-- OUTER JOIN (ok)
-- Nome das Empresas que nunca patrocinaram competições
SELECT E.NOME
FROM EMPRESA E LEFT OUTER JOIN PAT_COMP PC 
ON (E.CNPJ = PC.CNPJ_EMPRESA)
WHERE PC.CNPJ_EMPRESA IS NULL;

-- SUBCONSULTA DO TIPO TABELA (ok)
-- NOME DE EMPRESAS QUE PATROCINAM OU JA PATROCINARAM CLUBES
SELECT NOME
FROM EMPRESA 
WHERE CNPJ IN (SELECT CNPJ_EMPRESA
               FROM PAT_CLUBE);

--INNER JOIN: (ok)
-- Nome das Empresas que patrocinam ou patrocinavam clubes e seu respectivo clube patrocinado:
SELECT E.NOME, C.NOME
FROM CLUBE C INNER JOIN PAT_CLUBE PC 
ON (C.CODIGO = PC.CODIGO_CLUBE) INNER JOIN EMPRESA E 
ON (PC.CNPJ_EMPRESA = E.CNPJ);

--SUBCONSULTA DO TIPO ESCALAR (ok)
-- Codigo dos clubes que a empresa de nome 'Emirates' já patrrocinou ou patrocina:
SELECT PC.CODIGO_CLUBE
FROM PAT_CLUBE PC
WHERE PC.CNPJ_EMPRESA = (SELECT E.CNPJ
                 FROM EMPRESA E
                 WHERE E.NOME = 'EMIRATES');

--SUBCONSULTA DO TIPO LINHA (ok)
-- Projetar o nome dos funcionários que nasceram na mesmo ano e tem a mesma nacionalidade do funcionário de id '001'
SELECT F.NOME
FROM FUNCIONARIO F
WHERE (TO_CHAR(F.DT_NASCIMENTO, 'YYYY'), F.NACIONALIDADE) = (SELECT TO_CHAR(F2.DT_NASCIMENTO, 'YYYY'), F2.NACIONALIDADE
                                                             FROM FUNCIONARIO F2
                                                             WHERE F2.ID_FUNC = '001');

--ANTIJOIN (ok)
-- Projetar as ids das federações que não tem presidente
SELECT F.ID_FED
FROM FEDERACAO F
WHERE NOT EXISTS 
            (SELECT *
             FROM PRESIDENTE_DA_FEDERACAO PF
             WHERE PF.ID_FED = F.ID_FED);

-- SEMIJOIN (ok)
-- Projetar os nomes dos funcionários que já jogaram jogos
SELECT F.NOME
FROM FUNCIONARIO F
WHERE EXISTS
            (SELECT *
            FROM JOGADOR_PARTICIPA JP
            WHERE JP.ID_FUNC = F.ID_FUNC);
  
--GROUP BY/HAVING (ok)
-- Projetar as médias dos salários dos funcionários por clube onde as médias são maiores que 1000
SELECT C.NOME, TRUNC(AVG(F.SALARIO),2) AS MEDIA_SALARIO
FROM LIGADO L INNER JOIN FUNCIONARIO F 
ON (L.ID_FUNC = F.ID_FUNC) INNER JOIN CLUBE C
ON (L.CODIGO_CLUBE = C.CODIGO)
GROUP BY C.NOME
HAVING AVG(F.SALARIO) > 1000

-- CONJUNTOS (ok)
-- Selecionar todas as empresas que já patrocinaram ou patrocinam um clube ou competicao
SELECT E.NOME
FROM EMPRESA E INNER JOIN PAT_CLUBE PCLUBE
ON PCLUBE.CNPJ_EMPRESA = E.CNPJ  
UNION
SELECT E.NOME
FROM EMPRESA E INNER JOIN PAT_COMP PCOMP
ON PCOMP.CNPJ_EMPRESA = E.CNPJ;

-- GATILHOS --
-------------------------------------------------------------------

-- printando o nome do novo funcionário ao ser alterado a coluna 'Id_Func' de um funcionario ja existente
CREATE OR REPLACE TRIGGER SejaBemVindoAoClube
BEFORE UPDATE OF ID_FUNC ON FUNCIONARIO
FOR EACH ROW
BEGIN
    IF(:NEW.ID_FUNC<>:OLD.ID_FUNC)THEN
        DBMS_OUTPUT.PUT_LINE('FUNCIONARIO NOVO:' ||:NEW.ID_FUNC || ' ' || :NEW.NOME);
    END IF;
END;

-- printando o novo nome do funcionário
CREATE OR REPLACE TRIGGER MudancaDeNome 
BEFORE UPDATE OF NOME ON FUNCIONARIO   
FOR EACH ROW   
BEGIN   
    IF(:NEW.NOME<>:OLD.NOME)THEN   
        DBMS_OUTPUT.PUT_LINE('NOVO NOME: ' ||:NEW.NOME);   
    END IF;   
END;  

-- Procedimento para alterar o nome de um estádio
CREATE OR REPLACE PROCEDURE AtualizarNomeEstadio(
    p_cod_estadio IN ESTADIO.COD_ESTADIO%TYPE,
    p_novo_nome IN ESTADIO.NOME%TYPE
)
AS
BEGIN
    UPDATE ESTADIO
    SET NOME = p_novo_nome
    WHERE COD_ESTADIO = p_cod_estadio;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nome do estádio atualizado com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum estádio encontrado com o código digitado.');
    END IF;
END;
/

