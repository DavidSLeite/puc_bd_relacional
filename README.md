# Atividade Avaliativa: Projeto de Banco de Dados Relacional

## Regras de Entregas para o Projeto de Banco de Dados (SGBD PostgreSQL)

### 1. Modelo Conceitual
![](https://github.com/DavidSLeite/puc_bd_relacional/blob/main/artefatos/modelo_conceitual.png?raw=true)


### 2. Modelo Logico
![](https://github.com/DavidSLeite/puc_bd_relacional/blob/main/artefatos/modelo_logico.png?raw=true)

### 3. Modelo Físico (DDL)

```
-- Comandos DDL para criação das tabelas
CREATE TABLE tb_cad_cliente
(
 id_cliente serial NOT NULL,
 nome       varchar(100) NOT NULL,
 telefone   varchar(15) NOT NULL,
 cpf        varchar(14) NOT NULL,
 CONSTRAINT PK_Cliente PRIMARY KEY ( id_cliente )
);

CREATE TABLE tb_cad_carro
(
 id_carro     serial NOT NULL,
 numero_serie varchar(50) NOT NULL,
 marca        varchar(50) NOT NULL,
 modelo       varchar(50) NOT NULL,
 ano          int NOT NULL,
 tipo         varchar(10) NOT NULL,
 id_cliente   int NULL,
 CONSTRAINT PK_Carro PRIMARY KEY ( id_carro ),
 CONSTRAINT FK_Carro_2 FOREIGN KEY ( id_cliente ) REFERENCES tb_cad_cliente ( id_cliente )
);

CREATE TABLE tb_cad_vendedor
(
 id_vendedor serial NOT NULL,
 nome        varchar(100) NOT NULL,
 telefone    varchar(15) NOT NULL,
 cpf         varchar(14) NOT NULL,
 CONSTRAINT PK_Vendedor PRIMARY KEY ( id_vendedor )
);

CREATE TABLE tb_cad_fatura
(
 id_fatura   serial NOT NULL,
 data_venda  date NOT NULL,
 valor       decimal(10,2) NOT NULL,
 id_vendedor int NOT NULL,
 id_carro    int NOT NULL,
 CONSTRAINT PK_Fatura PRIMARY KEY ( id_fatura ),
 CONSTRAINT FK_Fatura_1 FOREIGN KEY ( id_vendedor ) REFERENCES tb_cad_vendedor ( id_vendedor ),
 CONSTRAINT FK_Fatura_2 FOREIGN KEY ( id_carro ) REFERENCES tb_cad_carro ( id_carro )
);

CREATE TABLE tb_cad_mecanico
(
 id_mecanico   serial NOT NULL,
 nome          varchar(100) NOT NULL,
 especialidade varchar(50) NULL,
 cpf           varchar(14) NOT NULL,
 CONSTRAINT PK_Mecanico PRIMARY KEY ( id_mecanico )
);

CREATE TABLE tb_cad_peca
(
 id_peca            serial NOT NULL,
 nome               varchar(100) NOT NULL,
 quantidade_estoque int NOT NULL,
 preco              decimal(10,2) NOT NULL,
 CONSTRAINT PK_Peca PRIMARY KEY ( id_peca )
);

CREATE TABLE tb_ticket_servico_manutencao
(
 id_ticket    serial NOT NULL,
 data_servico date NOT NULL,
 descricao    varchar(200) NOT NULL,
 id_carro     int NOT NULL,
 id_cliente   int NOT NULL,
 CONSTRAINT PK_TicketServico PRIMARY KEY ( id_ticket ),
 CONSTRAINT FK_TicketServico_1 FOREIGN KEY ( id_carro ) REFERENCES tb_cad_carro ( id_carro ),
 CONSTRAINT FK_TicketServico_2 FOREIGN KEY ( id_cliente ) REFERENCES tb_cad_cliente ( id_cliente )
);

CREATE TABLE tb_peca_utilizada
(
 id_peca_utilizada serial NOT NULL,
 id_ticket         int NOT NULL,
 id_peca           int NOT NULL,
 quantidade        int NOT NULL,
 CONSTRAINT PK_PecaUtilizada PRIMARY KEY ( id_peca_utilizada ),
 CONSTRAINT FK_PecaUtilizada_1 FOREIGN KEY ( id_ticket ) REFERENCES tb_ticket_servico_manutencao ( id_ticket ),
 CONSTRAINT FK_PecaUtilizada_2 FOREIGN KEY ( id_peca ) REFERENCES tb_cad_peca ( id_peca )
);


CREATE TABLE tb_servico_mecanico
(
 id_servico  serial NOT NULL,
 id_ticket   int NOT NULL,
 id_mecanico int NOT NULL,
 CONSTRAINT PK_ServicoMecanico PRIMARY KEY ( id_servico ),
 CONSTRAINT FK_ServicoMecanico_1 FOREIGN KEY ( id_ticket ) REFERENCES tb_ticket_servico_manutencao ( id_ticket ),
 CONSTRAINT FK_ServicoMecanico_2 FOREIGN KEY ( id_mecanico ) REFERENCES tb_cad_mecanico ( id_mecanico )
);

```

### 4. Consultas SQL
```
--Consulta 1
--Recuperar todos os carros vendidos por um vendedor específico, exibindo
--os detalhes do carro, o nome do cliente e o valor da fatura.

SELECT 
  vd.nome as vendedor,
	c.marca, 
	c.modelo, 
	c.ano, 
	cli.nome AS cliente, 
	f.valor
FROM tb_cad_carro c
JOIN tb_cad_fatura f ON c.id_carro = f.id_carro
JOIN tb_cad_cliente cli ON c.id_cliente = cli.id_cliente
JOIN tb_cad_vendedor vd on vd.id_vendedor = f.id_vendedor
WHERE f.id_vendedor = 1;

--Consulta 2
--Listar todos os serviços de manutenção realizados por um determinado
--mecânico, incluindo a descrição do serviço, o carro atendido e o cliente.

SELECT 
	  mc.nome as mecanico,
    ts.descricao, 
    c.marca, 
    c.modelo, 
    cli.nome AS cliente
FROM tb_servico_mecanico sm
JOIN tb_ticket_servico_manutencao ts ON sm.id_ticket = ts.id_ticket
JOIN tb_cad_carro c ON ts.id_carro = c.id_carro
JOIN tb_cad_cliente cli ON ts.id_cliente = cli.id_cliente
join tb_cad_mecanico mc on mc.id_mecanico = sm.id_mecanico
WHERE sm.id_mecanico = 1;

--Consulta 3
--Obter o histórico completo de manutenção de um carro específico, baseado
--no número de série, exibindo todos os serviços realizados e as peças utilizadas (se houver).

SELECT 
    ts.data_servico, 
    ts.descricao, 
    p.nome AS peca, 
    pu.quantidade
FROM tb_ticket_servico_manutencao ts
LEFT JOIN tb_peca_utilizada pu ON ts.id_ticket = pu.id_ticket
LEFT JOIN tb_cad_peca p ON pu.id_peca = p.id_peca
LEFT JOIN tb_cad_carro c ON ts.id_carro = c.id_carro
WHERE c.numero_serie = '111846184';

--Consulta 4
--Recuperar o total de vendas realizadas por cada vendedor em um
--determinado período, listando o nome do vendedor e o valor total das vendas.

SELECT 
    v.nome AS vendedor, 
    SUM(f.valor) AS total_vendas
FROM tb_cad_fatura f
JOIN tb_cad_vendedor v ON f.id_vendedor = v.id_vendedor
WHERE f.data_venda BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY v.nome;

--Consulta 5
--Listar todos os clientes que realizaram serviços de manutenção sem ter
--comprado um carro na concessionária, exibindo os detalhes do serviço e do cliente.

SELECT 
    cli.nome, 
    ts.descricao, 
    ts.data_servico
FROM tb_ticket_servico_manutencao ts
JOIN tb_cad_cliente cli ON ts.id_cliente = cli.id_cliente
LEFT JOIN tb_cad_carro c ON ts.id_carro = c.id_carro;

--Consulta 6
--Obter o estoque atual de todas as peças disponíveis, listando o nome da
--peça e a quantidade.

SELECT 
	nome, 
	quantidade_estoque
FROM tb_cad_peca;

--Consulta 7
--Obter o número total de carros vendidos por tipo (novo ou usado).

SELECT 
    cc.tipo, 
    COUNT(*) AS total_vendido
FROM tb_cad_carro cc
JOIN tb_cad_fatura cf ON cc.id_carro = cf.id_carro
GROUP BY tipo;

--Consulta 8
--Listar os mecânicos que realizaram mais de 5 serviços, listando o nome do
--mecânico e a quantidade de serviços

SELECT 
    m.nome, 
    COUNT(sm.id_servico) AS quantidade_servicos
FROM tb_servico_mecanico sm
JOIN tb_cad_mecanico m ON sm.id_mecanico = m.id_mecanico
GROUP BY m.nome
HAVING COUNT(sm.id_servico) > 5;

--Consulta 9
--Listar os carros que passaram por manutenção e não utilizaram peças.

SELECT 
    c.marca, 
    c.modelo, 
    ts.data_servico
FROM tb_ticket_servico_manutencao ts
JOIN tb_cad_carro c ON ts.id_carro = c.id_carro
LEFT JOIN tb_peca_utilizada pu ON ts.id_ticket = pu.id_ticket
WHERE pu.id_peca IS NULL;

--Consulta 10
--Obter o total gasto em peças por cada cliente em seus serviços.

SELECT 
    cli.nome, 
    SUM(p.preco * pu.quantidade) AS total_gasto
FROM tb_peca_utilizada pu
JOIN tb_cad_peca p ON pu.id_peca = p.id_peca
JOIN tb_ticket_servico_manutencao ts ON pu.id_ticket = ts.id_ticket
JOIN tb_cad_cliente cli ON ts.id_cliente = cli.id_cliente
GROUP BY cli.nome;
```
