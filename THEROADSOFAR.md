---
## Por onde eu começo?
Este texto descreve brevemente os principais passos e pesquisas que se fizeram necessárias para realizar este projeto.

Vale ressaltar que antes de fazer a PunkApi AWS Consumer,
nunca tinha trabalhado com versionamento de infraestrutura na AWS, somente no GCP.

Também não conhecia com profundidade o Kinesis e suas facilidades.

Confesso que me surpreedi bastante com a capacidade da ferramenta e o jeito fácil de se criar um _delivery stream_
para a fila.

---
## Entendi a stack que vou usar, mas e agora?
Meu primeiro passo foi criar uma conta grátis na AWS.

Com ela feita, fui ler sobre os serviços que compunham a arquitetura proposta para a resolução deste projeto.

Em um segundo momento, coloquei no papel tudo o que tinha pra ser feito e comecei a estruturar de forma lógica
os passos e o cronograma para resolver o desafio.

---
## Estruturando o Terraform
Após entendido o funcionamento dos componentes necessários para a realização do pojeto, comecei a estruturar o módulo do terraform
seguindo as orientações [deste video](https://www.youtube.com/watch?v=wgzgVm7Sqlk).

Decidi então separar os módulos por serviço e criar o ambiente `test` para que eu começasse a desenvolver.

A lógica é que para serviços produtivos, de qualidade, staging e outros, sejam criados outros ambientes separados, cada um com uma pasta dedicada.
Isso evita problemas graves que poderiam ocorrer em situações reais do dia a dia, como remoção de um ambiente inteiro.

Ao longo do desenvolvimento, fui percebendo somente os recursos listados para resolução do projeto não eram suficientes.
Eu teria que definir também os __roles do IAM__ para que os sistemas funcionassem como esperado. Além de claro, utilizar um bucket na própria S3
com permissionamento muito restrito para server de backend para o terraform.

---
## Código da Lambda Function
A princípio o código deveria realizar uma tarefa muito simples: fazer um `GET` no endpoint  `/v2/beers/random` da Punk Api e ingerir este
registro no Kinesis Stream. 

Porém, surgiu a curiosidade de tentar ingerir mais um registro por vez e decidi por fazer um código paralelo apenas para verificação.
Percebi que o Kinesis Firehose não separa os eventos _json_ que recebe por uma quebra de linha e portanto decidi por adicioná-la.

O código para verificação deste cenário está em `aws_lambda/main_async.py`

---
## O Makefile
Devido a complexidade de lidar com ambientes e realizar os testes necessários antes de fazer o _deploy_ da infraestrutura, decidi utilizar um Makefile
contendo as instruções para facilitar a utilização deste projeto.

---
## Github Actions
Todo o processo de testes e rebuilds se tornou repetitivo demais ao longo do aprendizado e a implementação do workflow no Github Actions me ajudou muito a desrobotizar esta tarefa!

Dessa forma, criei um yml de instruções para o CI/CD do projeto em `.github/workflows/pipeline-test.yml`

---
## Referências mais notáveis
Ao longo do processo de aprendizagem, os artigos que mais me elucidaram e me guiaram na resolução do problema foram:

- [Persist Streaming Data to Amazon S3 using Amazon Kinesis Firehose and AWS Lambda](https://aws.amazon.com/blogs/big-data/persist-streaming-data-to-amazon-s3-using-amazon-kinesis-firehose-and-aws-lambda/)
- [AWS Kinesis Firehose tutorial using Python](https://www.youtube.com/watch?v=msNff0Tc1Xc)
- [Real-Time Data Streaming with Python + AWS Kinesis — How To…](https://medium.com/swlh/real-time-data-streaming-with-python-aws-kinesis-how-to-part-1-cd56feb6fd0f)
- Github Actions: [Configuring a workflow](https://docs.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)
- [Fast & Asynchronous in Python](https://towardsdatascience.com/fast-and-async-in-python-accelerate-your-requests-using-asyncio-62dafca83c33)
