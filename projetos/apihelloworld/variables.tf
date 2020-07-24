variable "projectname" {
  default = "ProjetoHelloWorld"
  description = "Nome do projeto para tagueamento dos recursos"
}

variable "clustername" {
  default = "ClusterDemo"
  description = "Nome do cluster onde serão agrupados os serviços do projeto"
}

variable "api-repositoryname"{
  default = "repositorio-helloworld"
  description = "Repositório da imagem do docker"
}

variable "api-taskname"{
  default = "task-helloworld"
  description = "Nome da task executada pelo serviço"
}

variable "api-containername"{
  default = "container-helloworld"
  description = "Nome do conteiner excutado pela task"
}

variable "api-tg-name"{
  default = "target-helloworld"
  description = "Nome do target do load balance"
}

variable "api-srv-name"{
  default = "service-helloworld"
  description = "Nome do serviço que executara a task"
}

variable "api-pathpattern" {
  default = "/api/helloworld*"
  description = "Caminho de entrada para roteamento do load balance"
}

variable "healthpath" {
  default = "/api/helloworld/health"
  description = "Caminho para healthcheck da aplicação"
}