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