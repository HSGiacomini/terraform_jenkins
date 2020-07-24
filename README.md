# Terraform Jenkins AWS Fargate

Exemple de utilização do terraform para criação do mesmo código em contas diferentes da AWS.

## Pasta ambientes
Contém uma pasta para cada ambiente, com as variáveis comuns a todos eles

## Pasta projetos (ou sistemas)
Contém todos os projetos que podem ser criado em tempos diferentes nos diferentes ambientes.

## Pasta recursos
Contém os recursos que serão criados, isso evita que sejam replicados em cada novo projeto.