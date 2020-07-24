terraform {
    backend "s3" {
        bucket = "__BUCKETNAME__"
        key    = "modulos/apihelloworld.tfstate"
        region = "regiao_aws"
    }
}