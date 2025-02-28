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


