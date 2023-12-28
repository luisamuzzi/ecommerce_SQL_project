### Projeto de análise exploratória de dados com SQL para plataforma de gerenciamento de e-commerce:

### 1. Problema de negócio

Um dos maiores problemas dos comerciantes que possuem loja física é cadastrar o mesmo produto em dezenas de e-commerces disponíveis no Brasil para realizar vendas online.

Para resolver esse problema e facilitar o cadastro dos produtos em diferentes
portais de venda, uma grande empresa de tecnologia desenvolveu um serviço que faz todo esse processo automaticamente, fazendo com que o comerciante venda seus produtos através de um único site.

Todas as informações sobre o produto, o cliente, o comerciante, o meio de
pagamento, as avaliações e o pedido realizado são armazenados em um banco de dados.

Os gerentes da empresa acreditam que há muitas informações valiosas armazenas nos dados, mas não tem habilidades para explorar e encontrar as respostas para validar ou refutar suas hipóteses de negócio.

Portanto, você foi contratado como Cientista de Dados para explorar os dados e
trazer repostas sobre o que realmente está acontecendo com o negócio.

Nesse contexto, o objetivo desse projeto é criar consultas SQL para responder as perguntas de negócio feitas pelos gerentes. 

### 2. Premissas assumidas para a análise

- Utilizou-se os dados da Olist, que podem ser obtidos em: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- O modelo de negócio assumido é SaaS (Software as a Service) do segmento de e-commerce.

### 3. Estratégias da solução

As consultas SQL foram elaboradas com o objetivo de responder as perguntas de negócio. Dessa forma, foram utilizados: funções agregadoras, operadores de lógica, operadores condicionais, conceitos de união de tabelas, subqueries e window functions.

### 4. Top 5 Insights de dados

1. O ticket médio geral dos pedidos é de 120,65. No cartão de crédito, o ticket médio é 163,32;
2. Foram 99.441 clientes distintos realizando pedidos. São Paulo foi o estado com o maior número de clientes, seguido do Rio de Janeiro e Minas Gerais. Roraima foi o estado com o menor número de clientes;
3. A maioria dos pedidos é paga no cartão de crédito;
4. A categoria com maior número de produtos cadastrados é a de cama mesa e banho;
5. 57.420 clientes avaliaram o pedido com 5 estrelas, enquanto 11.858 avaliaram com 1 estrela.

### 5. O produto final do projeto

Um script SQL com as consultas realizadas. Os resultados também foram compilados num arquivo pdf contendo os prints dos resultados das queries.

### 6. Conclusão

O objetivo desse projeto foi criar um conjunto de consultas SQL para responder perguntas de negócio como parte de uma estratégia de análise exploratória dos dados da empresa.

As principais conclusões sugerem que:

- O ticket médio no cartão de crédito é 35% maior que o ticket médio geral, sendo essa a forma de pagamento mais utilizada.
- Os estados do sudeste possuem o maior número de clientes da plataforma.

### 7. Próximos passos

- Feita a análise exploratória, realizar análises diagnósticas e preditivas.
- Investigar dados inconsistentes evidenciados pela análise exploratória (por exemplo, categorias com tipo nulo, tipo de pagamento indefinido, compras com número de parcelas igual a zero).
