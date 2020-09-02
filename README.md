![PunkApi AWS Consumer CI/CD](https://github.com/flavio-assis/aws-punkapi-consumer/workflows/PunkApi%20AWS%20Consumer%20CI/CD/badge.svg)
# PunkApi AWS Consumer
Neste projeto eu implemento um consumidor para a PunkAPI utilizando serviços de nuvem da AWS (Lambda Function, Kinesis Stream, Kinesis Firehose e S3) e Terraform como minha Infraestrutura como código.

___
# Especificações:

Projeto: PunkApi AWS Consumer

Lingaguens:
  - python 3.8
  - Terraform

Produtos:
  - AWS Lambda 
  - Cloud Watch
  - Kinesis Stream
  - Kinesis Firehose
  - AWS S3
___

# Definição do Problema 

O projeto implementa uma arquitetura completa que consome a PunkApi no endpoint
https://api.punkapi.com/v2/beers/random e ingere em um Kinesis Stream que terá 1
consumidor.

Neste sentido, foi implementada a solução:

- Um CloudWatch Event dispara a cada 5 minutos uma execução de uma função Lambda
- Esta função Lambda alimenta o Kinesis Stream
- O Kinesis Stream em questão tem como saída um Kinesis Firehose
- Este Firehose, por sua vez agrega todas as entradas para guardar em um bucket S3

---
# Desenho da Arquitetura
![Image](.images/desenho_da_arquitura.png)

---
# Como usar o repositório
## Exportar suas credenciais da AWS
__Com Linux ou MacOS__
```
export AWS_ACCESS_KEY_ID=<< Seu ID de acesso >>
export AWS_SECRET_ACCESS_KEY=<< Sua Chave de acesso>>
export AWS_DEFAULT_REGION=<< Região >>
```
__Com Windows (CommandPrompt)__ 

```
setx AWS_ACCESS_KEY_ID=<< Seu ID de acesso >>
setx AWS_SECRET_ACCESS_KEY=<< Sua Chave de acesso>>
setx AWS_DEFAULT_REGION=<< Região >>
```
__Com Windows (PowerShell)__ 
```
$Env:AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
$Env:AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$Env:AWS_DEFAULT_REGION="us-west-2"
```

## Executar o Terraform Init
Depois de definidas as variáveis de ambiente, execute o commando:
```
make init ENV=<< Ambiente que você deseja iniciar >>
```

## Executar o Terraform Plan
Para realizar o Terraform Plan, você deverá executar o seguinte comando: 
```
make plan ENV=<< Ambiente que você deseja iniciar >>
```

## Executar os testes unitários e o Terraform Validate
Para realizar o Terraform Validate e os testes unitários dos módulos python da AWS Lambda Function, execute o comando:
```
make tests
```

## Executar o Terraform Plan
Finalmente, vocẽ deve executar o Terraform Apply, pelo comando a seguir: 
```
make apply ENV=<< Ambiente que você deseja iniciar >>
```
---
# Lambda Functions
Neste repositório estão definidas duas propostas de código para Lambda Function:
- Chamada apenas uma vez na API e escrita no Kinesis Stream
- Chamadas assíncronas na API e envio em lote para o Kinesis Stream

Em `terraform/test/terraform.tfvars` a versão unitária do código está sendo utilizada por default.

Para utilizar a versão em lote você deve alterar a variável `lambda_function_handler` 
no arquivo `terraform/test/terraform.tfvars` de forma que ela tenha o seguinte valor:

```
lambda_function_handler = "main_async.lambda_handler"
```
Você também pode configurar o máximo de chamadas por lote aterando a variável `lambda_get_api_max_requests`:
Exemplo:
```
lambda_get_api_max_requests = 500
```

---
# Estrutura do repositório
```
.
├── aws_lambda          # Define o código da Lambda Function        
│   ├── aws_lambda.zip  # Zipfile contendo o código a ser upado para a Cloud
│   ├── main_async.py   # Nesta versão da Lambda Function, ela faz requests assíncronos para o endpoint da PunkApi e insere os registros em lote no Stream
│   ├── main.py         # Nesta versão, a Lambda Function faz uma chamada unitária ao endpoint e faz a ingestão unitária no Stream
│   ├── package         # Pacotes necessários para o funcionamento da Lambda Function
│   └── tests           # Testes unitários da Lambda Function
|       ├── __init__.py
|       ├── test_get_record_from_api.py
|       └── test_send_message_to_ks.py
|
├── LICENSE             
├── Makefile            # Define alguns comandos prontos para facilitar a vida do usuário e facilitar a implementação de um CI/CD
├── README.md           
├── terraform           # Diretório onde são implementados todos os códigos do Terraform
│   ├── modules         # Modulos a serem resutilizados
│   │   ├── cloud_watch
│   │   │   ├── cloud_watch.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── iam
│   │   │   ├── iam.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── kinesis_firehose
│   │   │   ├── kinesis_firehose.tf
│   │   │   └── variables.tf
│   │   ├── kinesis_stream
│   │   │   ├── kinesis_stream.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── lambda
│   │   │   ├── lambda.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── lambda_trigger
│   │   │   ├── lambda_trigger.tf
│   │   │   └── variables.tf
│   │   └── s3
│   │       ├── outputs.tf
│   │       ├── s3.tf
│   │       └── variables.tf
│   └── test                   # Proposta de ambiente minimamente viável para a solução 
│       ├── backend.tf
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── THE_ROAD_SO_FAR.md         # Um pouco das minhas descobertas
```
---
# Nota:
Para esta etapa do desenvolvimento, somente o ambiente `test` foi impementado.
Você deverá definir os outros ambientes de sua necessidade (Produção, Staging, QA, etc)
no nível do `terraform/<< seu ambiente >>`.

Lembre-se que este nome deve ser o mesmo que você irá utilizar
quando for realizar as chamadas do `make`.

Exemplo:

Suponha que você tenha a necessidade de criar um ambiente produtivo.
Para isso você deve realizar os seguintes passos:

```
cd terraform
md prod
```
Faça o setup necessário para que seu ambiente se adeque a sua necessidade.
Faça o Terraform init:

```
make init ENV=prod
```
---