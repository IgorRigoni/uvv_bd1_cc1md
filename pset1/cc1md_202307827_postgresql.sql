--Remover o banco de dados com o nome uvv e o usuario igor caso ja exista
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS igor;

--Criar o usuario
CREATE USER igor CREATEDB CREATEROLE PASSWORD 'senha';

--Criar o banco de dados
CREATE DATABASE uvv
WITH
OWNER = igor
TEMPLATE = template0
ENCODING = "UTF8"
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = TRUE;

--Acessar o banco de dados criado
\c uvv;

--Alterar para o usuriario selecionado
SET ROLE = igor;

--Criar o esquema
CREATE SCHEMA lojas;

--Colocar o esquema criado anteriormente como principal
ALTER USER igor
SET SEARCH_PATH TO lojas, "$user", public;

--Criar a tabela produtos
CREATE TABLE lojas.produtos (
                produto_id 		 		  NUMERIC(38)  NOT NULL,
                nome 		   	 		  VARCHAR(255) NOT NULL,
                preco_unitario 	 		  NUMERIC(10,2),
                detalhes 		 		  BYTEA,
                imagem 			 		  BYTEA,
                imagem_mime_type 		  VARCHAR(512),
                imagem_arquivo   		  VARCHAR(512),
                imagem_charset   		  VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

--Adicionar constraint na tabela produtos
ALTER TABLE lojas.produtos
ADD CONSTRAINT preco_unitario CHECK (preco_unitario > 0);

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE  lojas.produtos IS 'tabela de cadastro de produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.produtos.nome IS 'nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'preço da unidade do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'detalhes sobre o produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'tipo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'tipo de arquivo da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'formato da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'data da ultima atualização da imagem do produto';

--Criar tabela lojas
CREATE TABLE lojas.lojas (
                loja_id 				NUMERIC(38)  NOT NULL,
                nome 					VARCHAR(255) NOT NULL,
                endereco_web 			VARCHAR(100),
                endereco_fisico 		VARCHAR(512),
                latitude 				NUMERIC,
                longitude 				NUMERIC,
                logo 					BYTEA,
                logo_mime_type 			VARCHAR(512),
                logo_arquivo 			VARCHAR(512),
                logo_charset 			VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);

--Adicionar constraint na tabela lojas
ALTER TABLE lojas.lojas
ADD CONSTRAINT check_endereco CHECK (endereco_web IS NOT NULL OR endereco_fisico IS NOT NULL);

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.lojas IS 'tabela de descrição das lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'link do site da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'localizacao da loja física';
COMMENT ON COLUMN lojas.lojas.latitude IS 'latitude da loja física';
COMMENT ON COLUMN lojas.lojas.longitude IS 'longitude da loja física';
COMMENT ON COLUMN lojas.lojas.logo IS 'logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'tipo da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'tipo de arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'formato da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'ultima vez que fizeram alteração na logo';

--Criar tabela estoques
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

--Adicionar constraint na tabela estoque
ALTER TABLE lojas.estoques
ADD CONSTRAINT quantidade CHECK (quantidade > 0);

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.estoques IS 'tabela com os estoques das lojas e com as quantidades dos produtos';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'numero de identificação do estoque';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidade de produtos disponível no estoque';

--Criar tabela clientes
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email 	   VARCHAR(255) NOT NULL,
                nome 	   VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.clientes IS 'tabela de cadastro dos clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'numero de identificação do cliente';
COMMENT ON COLUMN lojas.clientes.email IS 'email do cliente';
COMMENT ON COLUMN lojas.clientes.nome IS 'nome completo do cliente de acordo com o rg';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'segunda opção de telefone';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'terceira opção de telefone';

--Criar tabela envios
CREATE TABLE lojas.envios (
                envio_id 		 NUMERIC(38)  NOT NULL,
                loja_id 		 NUMERIC(38)  NOT NULL,
                cliente_id 		 NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status 			 VARCHAR(15)  NOT NULL,
                CONSTRAINT envios_id PRIMARY KEY (envio_id)
);

--Adicionar constraint na tabela envios
ALTER TABLE lojas.envios
ADD CONSTRAINT check_status_envios CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.envios IS 'tabela com as informações dos envios';
COMMENT ON COLUMN lojas.envios.envio_id IS 'numero de identificação do envio';
COMMENT ON COLUMN lojas.envios.loja_id IS 'numero de identificação da loja';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'numero de identificação do cliente';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'local para onde foi feito o envio';
COMMENT ON COLUMN lojas.envios.status IS 'etapa em que o envio se encontra';

--Criar tabela pedidos
CREATE TABLE lojas.pedidos (
                pedido_id  NUMERIC(38) NOT NULL,
                data_hora  TIMESTAMP   NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status 	   VARCHAR(15) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);

--Adicionar constraint na tabela pedidos
ALTER TABLE lojas.pedidos
ADD CONSTRAINT check_status_pedidos CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.pedidos IS 'tabela com a descrição dos pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'numero de identificação do pedido';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'dia e hora que foi realizado o pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'numero de identificação do cliente';
COMMENT ON COLUMN lojas.pedidos.status IS 'etapa em que o pedido se encontra';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'numero de identificação da loja';

--Criar tabela pedidos_itens
CREATE TABLE uvv.lojas.pedidos_itens (
                produto_id                  NUMERIC(38)     NOT NULL,
                pedido_id                   NUMERIC(38)     NOT NULL,
                numero_da_linha             NUMERIC(38)     NOT NULL,
                preco_unitario              NUMERIC(10,2)   NOT NULL,
                quantidade                  NUMERIC(38)     NOT NULL,
                envio_id                    NUMERIC(38)     NOT NULL,
			    CONSTRAINT pedidos_itens_pk PRIMARY KEY (produto_id, pedido_id)
);

--Adicionar comentário no banco de dados
COMMENT ON DATABASE uvv is 'Banco de dados do pset que contem dados sobre as lojas da uvv';

--Adicionar o cometariario na tabela e nas colunas
COMMENT ON TABLE lojas.pedidos_itens IS 'tabela dos itens que contem nos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'numero de identificação do pedido';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'numero de identificação do produto';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'linha em que se encontra o item no pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'preço unitario do item';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'quantidade do item de acordo com o pedido';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'numero de identificação do envio';

--Criar as FK das tabelas

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;